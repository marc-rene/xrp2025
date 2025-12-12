extends Node3D

@export var facing_down = false

func _ready() -> void:
	if facing_down == false:
		print("Starting off the sprinklers should be off!")
		$PickableObject/WATER_CAN_END/GPUParticles3D.emitting = false

func _physics_process(delta: float) -> void:
	var end: Node3D = $PickableObject/WATER_CAN_END
	if end == null:
		return 

	var forward: Vector3 = end.global_transform.basis.x.normalized()
	var down: Vector3 = Vector3.DOWN
	var alignment := forward.dot(down)

	# How much do be "mostly down" (e.g > cos(45d) ~ 0.707)
	if alignment > 0.35:
		facing_down = true
		$PickableObject/WATER_CAN_END/GPUParticles3D.emitting = true
		if $PickableObject/AudioStreamPlayer3D.playing == false:
			print("LLET IT RAIN")
			$PickableObject/AudioStreamPlayer3D.play()
	else:
		#print("No more rain")
		$PickableObject/AudioStreamPlayer3D.playing = false
		$PickableObject/WATER_CAN_END/GPUParticles3D.emitting = false
		facing_down = false
	$PickableObject/WATER_CAN_END/GPUParticles3D.amount_ratio = remap(alignment, 0.45, 0.99, 0, 0.8) #
	"""
    if alignment > 0.95:
        $PickableObject/WATER_CAN_END/GPUParticles3D.amount_ratio = 1
    elif alignment > 0.85:
        $PickableObject/WATER_CAN_END/GPUParticles3D.amount_ratio = 0.9
    elif alignment > 0.75:
        $PickableObject/WATER_CAN_END/GPUParticles3D.amount_ratio = 0.8
    elif alignment > 0.7:
        $PickableObject/WATER_CAN_END/GPUParticles3D.amount = 80
	"""        
