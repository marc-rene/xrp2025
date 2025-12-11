extends Node

@export var Days_per_Second = 8/0.3333 # 8 days pass for every 0.333 seconds of play


func _start_growing_():
    $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation = "Scene"
    $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale = Days_per_Second
    
    
