extends Node3D

# --- Node references ---
@onready var soil_mesh: MeshInstance3D = $SoilMesh

# --- Heightmap ---
var heightmap_img: Image
var heightmap_tex: ImageTexture
const HM_SIZE: int = 256

#bleh comment to make push

# READY
func _ready() -> void:
	print("\n=== SOIL READY ===")

	if XRServer.find_interface("OpenXR").is_initialized() == false:
		print("Using Backup cam")
	else:
		print("Not using Backup cam")

	# CONNECT PLOUGH DIGGING SIGNAL
	var plough := get_node_or_null("Plough")
	if plough:
		plough.plough_dig.connect(_on_plough_dig)
		print("DEBUG: Connected Plough → Soil signal")
	else:
		print("DEBUG ERROR: Plough NOT FOUND in scene")

	_validate_scene_setup()
	_create_heightmap()
	_apply_heightmap_to_material()

	print("=== READY COMPLETE ===\n")




# VALIDATION — DEBUGGING HELP
func _validate_scene_setup() -> void:
	print("\n=== Soil Scene Validation ===")

	if soil_mesh == null:
		push_error("ERROR: SoilMesh node NOT found at $SoilMesh")
	else:
		print("DEBUG: SoilMesh found:", soil_mesh)

	# Validate material
	var mat := soil_mesh.get_active_material(0)
	if mat == null:
		push_error("ERROR: SoilMesh has NO MATERIAL.")
	elif not (mat is ShaderMaterial):
		push_error("ERROR: SoilMesh material is NOT a ShaderMaterial.")
	else:
		print("DEBUG: ShaderMaterial found")

	# Validate collider
	var col := $Soilcollison/CollisionShape3D
	if col == null:
		push_error("ERROR: CollisionShape3D NOT FOUND under Soilcollision!")
	else:
		print("DEBUG: Collider found:", col, "Shape:", col.shape)

	print("=== Validation Complete ===\n")




# CREATE HEIGHTMAP
func _create_heightmap() -> void:
	print("DEBUG: Creating heightmap…")

	heightmap_img = Image.create(HM_SIZE, HM_SIZE, false, Image.FORMAT_RF)

	for x in range(HM_SIZE):
		for y in range(HM_SIZE):
			heightmap_img.set_pixel(x, y, Color(0.5, 0.0, 0.0))

	heightmap_tex = ImageTexture.create_from_image(heightmap_img)

	print("DEBUG: Heightmap created")




# APPLY HEIGHTMAP TO SHADER
func _apply_heightmap_to_material() -> void:
	print("DEBUG: Applying heightmap to material…")

	var mat := soil_mesh.get_surface_override_material(0)
	if mat == null:
		mat = soil_mesh.get_active_material(0)

	if mat == null:
		print("DEBUG ERROR: SoilMesh has NO MATERIAL")
		return

	if not (mat is ShaderMaterial):
		print("DEBUG ERROR: SoilMesh material is NOT ShaderMaterial")
		return

	var shader_mat: ShaderMaterial = mat
	shader_mat.set_shader_parameter("heightmap", heightmap_tex)

	print("DEBUG: Heightmap applied to shader!")




# HANDLE DIGGING TRIGGERED BY THE PLOUGH TOOL
func _on_plough_dig(world_pos: Vector3) -> void:
	print("\nDEBUG: Soil received DIG signal at:", world_pos)
	dig_at_world_position(world_pos, 0.45, 0.10)



# DIGGING FUNCTION
func dig_at_world_position(world_pos: Vector3, radius: float = 0.5, depth: float = 0.1) -> void:
	print("\n--- DIG FUNCTION START ---")
	print("DEBUG: world_pos =", world_pos)

	# Convert world -> local
	var local_pos: Vector3 = soil_mesh.to_local(world_pos)
	print("DEBUG: local_pos =", local_pos)

	var plane_mesh: PlaneMesh = soil_mesh.mesh as PlaneMesh
	if plane_mesh == null:
		print("DEBUG ERROR: SoilMesh.mesh is NOT PlaneMesh")
		return

	var size_x: float = plane_mesh.size.x
	var size_z: float = plane_mesh.size.y
	print("DEBUG: soil size =", size_x, size_z)

	# Convert to UV (0–1)
	var u: float = (local_pos.x / size_x) + 0.5
	var v: float = (local_pos.z / size_z) + 0.5
	print("DEBUG: UV =", u, v)

	if u < 0.0 or u > 1.0 or v < 0.0 or v > 1.0:
		print("DEBUG: UV OUT OF RANGE — NO DIG")
		return

	# UV -> pixel
	var cx: int = int(u * HM_SIZE)
	var cy: int = int(v * HM_SIZE)
	print("DEBUG: Pixel coords =", cx, cy)

	var max_dim: float = max(size_x, size_z)
	var rad_pix: int = int(radius * float(HM_SIZE) / max_dim)
	print("DEBUG: rad_pix =", rad_pix)

	print("DEBUG: Height BEFORE dig =", heightmap_img.get_pixel(cx, cy).r)

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

	print("DEBUG: Height AFTER dig =", heightmap_img.get_pixel(cx, cy).r)
	print("--- DIG FUNCTION END ---\n")




# MOUSE CLICK DIGGING TEST
func do_bang(origin, dir):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origin, origin + dir * 100.0)
	var hit = space.intersect_ray(query)
	
	if hit.is_empty():
		print("NO HIT — ray missed the collider.")
		return

	print("Hit object: ", hit.collider)
	print("Hit position: ", hit.position)

	dig_at_world_position(hit.position, 0.5, 0.12)


func _on_xr_controller_left_hand_button_pressed(name: String) -> void:
	pass
