extends Node3D

@onready var Anim_Player_refs : Array[AnimationPlayer]

func _ready() -> void:
    Anim_Player_refs = [
        $"Potatoe #1/AnimationPlayer",
        $"Potatoe #2/AnimationPlayer",
        $"Potatoe #3/AnimationPlayer",
        $"Potatoe #Lose patience/AnimationPlayer",
        $"Potatoe #Lost Patience/AnimationPlayer",
        $"Potatoe #AAAAAHHHHHH/AnimationPlayer"
    ]
    for anim in Anim_Player_refs:
        anim.current_animation = "Scene"
        anim.play()
        await get_tree().create_timer(2).timeout
