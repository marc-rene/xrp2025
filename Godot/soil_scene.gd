extends Node3D

@onready var soil_mesh: MeshInstance3D = $SoilMesh

var heightmap_img: Image
var heightmap_tex: ImageTexture

const HM_SIZE: int = 256  # resolution of the heightmap

func _ready() -> void:
	_create_heightmap()
	_apply_heightmap_to_material()


func _create_heightmap() -> void:
	# Create grayscale image with all pixels at 0.5 (flat)
	heightmap_img = Image.create(HM_SIZE, HM_SIZE, false, Image.FORMAT_RF)
	heightmap_img.lock()
	for x in range(HM_SIZE):
		for y in range(HM_SIZE):
			heightmap_img.set_pixel(x, y, Color(0.5, 0.0, 0.0))
	heightmap_img.unlock()

	heightmap_tex = ImageTexture.create_from_image(heightmap_img)


func _apply_heightmap_to_material() -> void:
	var mat: ShaderMaterial = soil_mesh.get_surface_override_material(0) as ShaderMaterial
	if mat == null:
		mat = soil_mesh.get_active_material(0) as ShaderMaterial
	if mat == null:
		push_warning("SoilMesh has no ShaderMaterial.")
		return

	mat.set_shader_parameter("heightmap", heightmap_tex)


func dig_at_world_position(world_pos: Vector3, radius: float = 0.5, depth: float = 0.1) -> void:
	# Convert world pos → local pos of SoilMesh
	var local_pos: Vector3 = soil_mesh.to_local(world_pos)

	var plane_mesh := soil_mesh.mesh as PlaneMesh
	if plane_mesh == null:
		return

	var size_x: float = plane_mesh.size.x
	var size_z: float = plane_mesh.size.y

	# Map local XZ (centered -size/2..+size/2) → UV 0..1
	var u: float = (local_pos.x / size_x) + 0.5
	var v: float = (local_pos.z / size_z) + 0.5

	if u < 0.0 or u > 1.0 or v < 0.0 or v > 1.0:
		return

	var center_x: int = int(u * float(HM_SIZE))
	var center_y: int = int(v * float(HM_SIZE))

	# approximate radius in pixels
	var max_size: float = max(size_x, size_z)
	var rad_pixels: int = max(1, int(radius * float(HM_SIZE) / max_size))

	heightmap_img.lock()
	for x in range(center_x - rad_pixels, center_x + rad_pixels + 1):
		for y in range(center_y - rad_pixels, center_y + rad_pixels + 1):
			if x < 0 or x >= HM_SIZE or y < 0 or y >= HM_SIZE:
				continue
			var dist = Vector2(x, y).distance_to(Vector2(center_x, center_y))
			if dist <= rad_pixels:
				var current_h: float = heightmap_img.get_pixel(x, y).r
				var strength: float = 1.0 - (dist / float(rad_pixels)) # softer at edges
				var new_h: float = clamp(current_h - depth * strength, 0.0, 1.0)
				heightmap_img.set_pixel(x, y, Color(new_h, 0.0, 0.0))
	heightmap_img.unlock()

	heightmap_tex.update(heightmap_img)
