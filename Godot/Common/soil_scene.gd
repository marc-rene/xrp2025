extends Node3D

# --- Node references ---
@onready var soil_mesh: MeshInstance3D = $SoilMesh
@onready var cam: Camera3D = $Camera3D   # Used for mouse-based digging test

# --- Heightmap ---
var heightmap_img: Image
var heightmap_tex: ImageTexture
const HM_SIZE: int = 256



# READY

func _ready() -> void:
	_validate_scene_setup()
	_create_heightmap()
	_apply_heightmap_to_material()




# VALIDATION — DEBUGGING HELP
func _validate_scene_setup() -> void:
	print("\n=== Soil Scene Validation ===")

	if soil_mesh == null:
		push_error("ERROR: SoilMesh node NOT found at $SoilMesh")
	else:
		print("SoilMesh FOUND")

	# Validate material
	var mat := soil_mesh.get_active_material(0)
	if mat == null:
		push_error("ERROR: SoilMesh has NO MATERIAL.")
	elif not (mat is ShaderMaterial):
		push_error("ERROR: SoilMesh material is NOT a ShaderMaterial.")
	else:
		print("ShaderMaterial FOUND")

	# Validate collider
	var col := $Soilcollison/CollisionShape3D
	if col == null:
		push_error("ERROR: CollisionShape3D NOT FOUND under Soilcollision!")
	else:
		print("CollisionShape3D FOUND")

	if col and col.shape == null:
		push_error("ERROR: CollisionShape3D HAS NO SHAPE ASSIGNED!")
	elif col:
		print("Collider Shape OK: ", col.shape)

	print("=== Validation Complete ===\n")




# CREATE HEIGHTMAP

func _create_heightmap() -> void:
	heightmap_img = Image.create(HM_SIZE, HM_SIZE, false, Image.FORMAT_RF)

	for x in range(HM_SIZE):
		for y in range(HM_SIZE):
			heightmap_img.set_pixel(x, y, Color(0.5, 0.0, 0.0))

	heightmap_tex = ImageTexture.create_from_image(heightmap_img)




# APPLY HEIGHTMAP TO SHADER

func _apply_heightmap_to_material() -> void:
	var mat := soil_mesh.get_surface_override_material(0)
	if mat == null:
		mat = soil_mesh.get_active_material(0)

	if mat == null:
		push_warning("WARNING: SoilMesh has NO MATERIAL")
		return

	if not (mat is ShaderMaterial):
		push_warning("WARNING: SoilMesh material is NOT a ShaderMaterial")
		return

	var shader_mat: ShaderMaterial = mat
	shader_mat.set_shader_parameter("heightmap", heightmap_tex)



# -------------------------------------------------------
# DIGGING FUNCTION
# -------------------------------------------------------
func dig_at_world_position(world_pos: Vector3, radius: float = 0.5, depth: float = 0.1) -> void:
	# Convert world -> local
	
	var local_pos: Vector3 = soil_mesh.to_local(world_pos)

	var plane_mesh: PlaneMesh = soil_mesh.mesh as PlaneMesh
	if plane_mesh == null:
		push_warning("WARNING: SoilMesh.mesh is NOT PlaneMesh — cannot compute UVs.")
		return

	var size_x: float = plane_mesh.size.x
	var size_z: float = plane_mesh.size.y
	if size_x == 0.0 or size_z == 0.0:
		push_warning("WARNING: PlaneMesh size is zero — invalid soil size")
		return

	# Convert to UV (0–1)
	var u: float = (local_pos.x / size_x) + 0.5
	var v: float = (local_pos.z / size_z) + 0.5
	print("UV:", u, v)
	if u < 0.0 or u > 1.0 or v < 0.0 or v > 1.0:
		return  # click outside soil plane

	# UV -> pixel
	var cx: int = int(u * HM_SIZE)
	var cy: int = int(v * HM_SIZE)

	var max_dim: float = max(size_x, size_z)
	if max_dim == 0.0:
		return

	var rad_pix: int = int(radius * float(HM_SIZE) / max_dim)

	# Modify heightmap pixels
	for x in range(cx - rad_pix, cx + rad_pix + 1):
		for y in range(cy - rad_pix, cy + rad_pix + 1):
			if x < 0 or x >= HM_SIZE or y < 0 or y >= HM_SIZE:
				continue

			var dist: float = Vector2(x, y).distance_to(Vector2(cx, cy))
			if dist <= rad_pix:
				var current_h: float = heightmap_img.get_pixel(x, y).r
				var softness: float = 1.0 - dist / float(rad_pix)
				var new_h: float = clamp(current_h - depth * softness, 0.0, 1.0)
				heightmap_img.set_pixel(x, y, Color(new_h, 0.0, 0.0))

	heightmap_tex.update(heightmap_img)



# -------------------------------------------------------
# MOUSE CLICK DIGGING TEST
# -------------------------------------------------------
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		var origin = cam.project_ray_origin(event.position)
		var dir = cam.project_ray_normal(event.position)

		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(origin, origin + dir * 100.0)
		var hit = space.intersect_ray(query)

		if hit.is_empty():
			print("NO HIT — ray missed the collider.")
			return

		print("Hit object: ", hit.collider)
		print("Hit position: ", hit.position)

		# No more collider == soil_mesh restriction, this simplifies testing
		dig_at_world_position(hit.position, 0.5, 0.12)
