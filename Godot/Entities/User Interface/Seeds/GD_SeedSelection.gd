extends Node3D

@export var StartMenu_ref : XRToolsViewport2DIn3D

func _ready() -> void:
    StartMenu_ref.SIGNAL_Start.connect(_on_start_select)
    
func _on_start_select():
    print("GREAT SIGNAL SUCCESS!!!")
