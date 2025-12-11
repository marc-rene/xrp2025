extends Node3D

signal plough_dig(world_pos: Vector3)

@onready var blade_area: Area3D = $Blade
@onready var pickable = $XRToolsPickable

var is_held := false
var touching_soil := false
var last_pos := Vector3.ZERO


func _ready():
	# Connect blade collisions
	blade_area.body_entered.connect(_on_blade_enter)
	blade_area.body_exited.connect(_on_blade_exit)
	
func _on_blade_enter(body):
	if body.is_in_group("soil"):
		touching_soil = true
		print("Blade touching soil")


func _on_blade_exit(body):
	if body.is_in_group("soil"):
		touching_soil = false
		print("Blade left soil")


func _physics_process(delta):
	if not is_held:
		return
	if not touching_soil:
		return

	# Detect dragging motion
	var current = global_transform.origin
	var movement = current.distance_to(last_pos)

	if movement > 0.01:
		# Emit world pos at blade contact point
		var contact_pos = blade_area.global_transform.origin
		emit_signal("plough_dig", contact_pos)
		print("DIG:", contact_pos)

	last_pos = current
