extends Node

@export var video_ref : VideoStreamPlayer



func _play_the_video_():
    if video_ref == null:
        video_ref = $MarginContainer/AspectRatioContainer/VideoStreamPlayer
    if video_ref.is_playing() != true:
        video_ref.play()
    
