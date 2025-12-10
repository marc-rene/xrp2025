extends Node

@export var Video_Ref : Node3D
@export var seed_name = "NaN"
@onready var world_environment:WorldEnvironment
var clicks = 0

func _on_button_pressed() -> void:
    clicks += 1
    if clicks == 1:
        if Video_Ref == null:
            if seed_name == "POTATO":
                Video_Ref = $"../../../Potato Video"
            else:
                Video_Ref = $"../../../Wheat seed"
        if Video_Ref != null:
            if seed_name == "POTATO":
                Video_Ref._play_included_video_()
                print("Playing vid")
            else:
                Video_Ref._play_included_video_()
                
        else:
            print("ERROR: Video reference is null")
    elif clicks > 1:
        GlobalVariables.SELECTED_SEED = seed_name
        var tween = create_tween()
        if world_environment == null:
            world_environment = get_node("/root/MainMenu/WorldEnvironment")
        tween.tween_property(world_environment.environment , "background_energy_multiplier", 0.0, 2.0)
        await get_tree().create_timer(2).timeout
        get_tree().change_scene_to_file("res://Levels/soil_scene.tscn")
