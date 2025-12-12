extends Node3D

signal plough_dig(world_pos: Vector3)

@onready var blade_area: Area3D = $PickableObject/Blade
@onready var pickable := $PickableObject

var is_held := false
var touching_soil := false
var last_pos := Vector3.ZERO


func _ready():
	# Connect XRTools pick-up signals
	pickable.picked_up.connect(_on_picked_up)
	pickable.released.connect(_on_released)

	# Connect blade collision signals
	blade_area.body_entered.connect(_on_blade_enter)
	blade_area.body_exited.connect(_on_blade_exit)

	print("Plough ready. Waiting for pickup.")


# XRTools: object is grabbed
func _on_picked_up(by):
	is_held = true
	last_pos = global_transform.origin
	print("Plough picked up")


# XRTools: object released
func _on_released(what, by):
	is_held = false
	print("Plough released")


func _on_blade_enter(body):
	if body.is_in_group("soil"):
		touching_soil = true
		print("Blade touching soil!")


func _on_blade_exit(body):
	if body.is_in_group("soil"):
		touching_soil = false
		print("Blade left soil!")


func _physics_process(delta):
	if not is_held:
		return
	if not touching_soil:
		return

	var current = blade_area.global_transform.origin
	var moved := current.distance_to(last_pos)

	if moved > 0.01:
		var contact_pos = blade_area.global_transform.origin
		print("DIG:", contact_pos)
		emit_signal("plough_dig", contact_pos)
		$AudioStreamPlayer3D.play()

	last_pos = blade_area.global_transform.origin
