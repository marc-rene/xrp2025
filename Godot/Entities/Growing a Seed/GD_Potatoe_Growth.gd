extends Node

# 8 days pass for every 0.333 seconds of play
# 1 day pass for every 0.04162 seconds of play
# 10 days pass for every 0.41625 seconds of play
# 24 days pass for every second of play
@export var Speed_Scale = 0.1

var start_spawn_of_new_potatoes = false

func _ready():
	$"New Tatters".visible = false


func _update_speed_scale(new_speed):
	$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale = new_speed


func _start_growing():
	$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation = "Scene"
	_update_speed_scale(Speed_Scale)
	for day in range(90):
		$Label3D.text = "Day: %d" % day
		await get_tree().create_timer(0.041625 / $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale).timeout
		if day == 80:
			$"New Tatters".scale(0.01)
			$"New Tatters".visible = false
			var growy_tween = create_tween()
			growy_tween.tween_property($"New Tatters", "scale", 1, (0.041625 / $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale)* 20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
