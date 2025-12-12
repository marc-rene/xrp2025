extends Node3D

const POTATO_SCENE : PackedScene = preload("res://Entities/Growing a Seed/Potato_seed_Growing.tscn")

func _ready() -> void:
	if GlobalVariables.SEED_PLANT_LOCATIONS == null or GlobalVariables.SEED_PLANT_LOCATIONS.size() <= 0:
		#print("CRAP! Never planted anything... assuming 3,0,0 for now")
		#GlobalVariables.SEED_PLANT_LOCATIONS.push_front(Vector3(3,0,0))
		pass
		
	if GlobalVariables.SELECTED_SEED == "POTATO" or GlobalVariables.SELECTED_SEED == null:
		print("Using potato growing")
		#for spuddy_idx in range(GlobalVariables.SEED_PLANT_LOCATIONS.size()):
		var spud = $PotatoSeedGrowing
		$PotatoSeedGrowing/Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation = "Scene"
		$PotatoSeedGrowing/Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.pause()
		
		spud.scale = Vector3.ZERO
		var tween = create_tween()
		var overshoot_scale = Vector3(1.2,1.5,1.2)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(spud, "scale", overshoot_scale, 0.25)
		print("Creating spud timer")
		await get_tree().create_timer(0.25).timeout
		tween.tween_property(spud, "scale", Vector3.ONE, 0.15)
		print("Spud should be fully spawned by now")
		
		
var do_once = true
func _physics_process(delta: float) -> void:
	if $PotatoSeedGrowing/Label3D.text == "TAYTO FOR EVERYONE" and do_once:
		do_once = false
		print("Playing potato awesomeness video")
		$VideoPlayer3d._play_the_video_()
		$VideoPlayer3d2._play_the_video_()
		
