extends Node3D

@export var Video_Ref : VideoStreamPlayer
@onready var world_environment:WorldEnvironment
var clicks = 0

func _on_button_pressed() -> void:
    clicks += 1
    if clicks == 1:
        if Video_Ref != null:
            Video_Ref.play()
            print("Playing vid")
        else:
            print("ERROR: Video reference is null")
    elif clicks > 1:
        
        var tween = create_tween()
        if world_environment == null:
            world_environment = get_node("/root/MainMenu/WorldEnvironment")
        tween.tween_property(world_environment.environment , "background_energy_multiplier", 0.0, 2.0)
        await get_tree().create_timer(2).timeout
        get_tree().change_scene_to_file("res://Levels/soil_scene.tscn")
