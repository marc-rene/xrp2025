extends Node3D

const POTATO_SCENE : PackedScene = preload("res://Entities/Growing a Seed/Potato_seed_Growing.tscn")

func _ready() -> void:
    if GlobalVariables.SEED_PLANT_LOCATIONS == null or GlobalVariables.SEED_PLANT_LOCATIONS.size() <= 0:
        print("CRAP! Never planted anything... assuming 3,0,0 for now")
        GlobalVariables.SEED_PLANT_LOCATIONS[0] = Vector3(3,0,0)
        
    if GlobalVariables.SELECTED_SEED == "POTATO" or GlobalVariables.SELECTED_SEED == null:
        for spuddy_idx in range(GlobalVariables.SEED_PLANT_LOCATIONS.size()):
            var spud : Node3D = POTATO_SCENE.instantiate()
            add_child(spud)
            spud.global_position = GlobalVariables.SEED_PLANT_LOCATIONS[spuddy_idx]
            spud.scale = Vector3.ZERO
            var tween := create_tween()
            var overshoot_scale = Vector3(1.2,1.5,1.2)
            tween.tween_property(spud, "scale", overshoot_scale, 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).tween_property(spud, "scale", Vector3.ONE, 0.15)
            
