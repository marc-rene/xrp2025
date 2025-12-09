extends Node3D

signal SIGNAL_Start

@export var UI_AudioStreamPlayer_ref : AudioStreamPlayer
@onready var environment:Environment = $"WorldEnvironment".environment
var exit_sound = load("res://Audio/good-game.ogg")

func _on_btn_exit_pressed() -> void:
    UI_AudioStreamPlayer_ref.stream = exit_sound
    UI_AudioStreamPlayer_ref.play(0)
    var tween = create_tween()
    tween.tween_property(environment , "background_energy_multiplier", 0.0, 2.0)
    await get_tree().create_timer(3).timeout
    get_tree().quit(0)


func _on_btn_start_pressed() -> void:
    SIGNAL_Start.emit() 
