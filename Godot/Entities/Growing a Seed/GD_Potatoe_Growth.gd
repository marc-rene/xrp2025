extends Node

# 8 days pass for every 0.333 seconds of play
# 1 day pass for every 0.04162 seconds of play
# 10 days pass for every 0.41625 seconds of play
# 24 days pass for every second of play
@export var Speed_Scale = 0.1

var start_spawn_of_new_potatoes = false

func _ready():
	$"New Tatters".visible = false
	$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation = "Scene"
	$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation_position = 0

func _update_speed_scale(new_speed):
	$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale = new_speed
	print("Growing Speed is now ", new_speed)

var keep_going = false
func _start_growing():
	print("STARTED GROWING MASHALLAH")
	$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation = "Scene"
	$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation_position = 0
	_update_speed_scale(Speed_Scale)
	for day in range(90):
		print("On day: ", day)
		if keep_going == false:
			day -= 1
		else:
			$Label3D.text = "Day: %d" % day
			await get_tree().create_timer(0.041625 / $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale).timeout
			if day == 80:
				$"New Tatters".scale(0.01)
				$"New Tatters".visible = false
				var growy_tween = create_tween()
				growy_tween.tween_property($"New Tatters", "scale", 1, (0.041625 / $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale)* 20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("HEY ", body.name, " JUST ENTERED")
	if body.name == "PickupableWaterCan":
		print("Should Start to grow")
		keep_going = true
		_start_growing()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "PickupableWaterCan":
		print("Should STOP to grow")
		keep_going = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.name == "WATER_CAN_END" or area.name == "PickupableWaterCan":
		print("Should START to grow")
		if $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation_position <= 0.01:
			_start_growing()
			keep_going = true
		else:
			keep_going = true


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.name == "WATER_CAN_END" or area.name == "PickupableWaterCan":
		print("Should STOP to grow")
		keep_going = false 
