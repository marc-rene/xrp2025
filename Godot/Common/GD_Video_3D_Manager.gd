extends Node3D

@export var CanvasLayerToUse : Resource

func _play_the_video_():
    $Viewport2Din3D.scene = CanvasLayerToUse
    #$Viewport2Din3D.scene._play_the_video_() # This crashes... WHY?
    
