extends Node3D

@export var Video_Ref : VideoStreamPlayer

func _on_button_pressed() -> void:
    if Video_Ref != null:
        Video_Ref.play()
    
