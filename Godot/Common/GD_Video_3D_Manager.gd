extends Node3D

@export var Video_Placeholder_ref : XRToolsViewport2DIn3D
@export var CanvasLayerToUse : Resource

func _play_included_video_():
    Video_Placeholder_ref._play_the_video_()
