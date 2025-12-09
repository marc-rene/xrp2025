extends Node3D

@export var StartMenu_ref : Node

func _ready() -> void:
    #StartMenu_ref.SIGNAL_Start.connect(_on_start_select)
    visible = false
    pass
    
func _on_start_select():
    visible = true
    print("GREAT SIGNAL SUCCESS!!!")
