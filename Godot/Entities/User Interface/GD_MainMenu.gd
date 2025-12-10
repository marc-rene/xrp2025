extends Node


@export var UI_AudioStreamPlayer_ref : AudioStreamPlayer
@export var world_environment : WorldEnvironment
@export var exit_sound : AudioStream

func _on_btn_exit_pressed() -> void:
    if UI_AudioStreamPlayer_ref == null:
        UI_AudioStreamPlayer_ref = $"../../../Player/UI_AudioPlayer"
    UI_AudioStreamPlayer_ref.stream = exit_sound
    UI_AudioStreamPlayer_ref.play(0)
    var tween = create_tween()
    if world_environment == null:
        world_environment = $"../../../WorldEnvironment"
    tween.tween_property(world_environment.environment , "background_energy_multiplier", 0.0, 2.0)
    await get_tree().create_timer(3).timeout
    get_tree().quit(0)


func _on_btn_start_pressed() -> void:
    $"../../../All Seeds"._on_start_select()
