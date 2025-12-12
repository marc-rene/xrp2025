extends Node

# 8 days pass for every 0.333 seconds of play
# 1 day pass for every 0.04162 seconds of play
# 10 days pass for every 0.41625 seconds of play
# 24 days pass for every second of play
@export var Speed_Scale = 0.1
@export var Water_Can_Ref : Node3D

var check_if_we_waterin_again = false
var start_spawn_of_new_potatoes = false

func _ready():
    $"New Tatters".visible = false
    $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation = "[stop]"
    #$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation_position = 0

func _update_speed_scale(new_speed):
    $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale = new_speed
    print("Growing Speed is now ", new_speed)

var keep_going = false
func _start_growing():
    print("STARTED GROWING MASHALLAH")
    $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation = "Scene"
    #$Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation_position = 0
    _update_speed_scale(Speed_Scale)
    for day in range(90):
        print("On day: ", day)
        $Label3D.text = "Day: %d" % day
        await get_tree().create_timer(0.041625 / $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale).timeout
        print("Timer finished")
        if day == 80:
            print("Day was 80, starting new tween for new spuds")
            $"New Tatters".scale = Vector3(0.01, 0.01, 0.01)
            $"New Tatters".visible = true
            var growy_tween = create_tween()
            growy_tween.tween_property($"New Tatters", "scale", Vector3.ONE, (0.041625 / $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.speed_scale)* 20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    $Label3D.text = "TAYTO FOR EVERYONE"

"""
func _on_area_3d_body_entered(body: Node3D) -> void:
    #print("HEY ", body.name, " JUST ENTERED")
    if body.name == "PickupableWaterCan":
        print("Should Start to grow")
        keep_going = true
        _start_growing()


func _on_area_3d_body_exited(body: Node3D) -> void:
    if body.name == "PickupableWaterCan":
        print("Should STOP to grow")
        keep_going = false
"""

func start_the_show():
    if $Potatoe_WORK_CURSE_YOU_DAMN/AnimationPlayer.current_animation_position <= 0.01:
        _start_growing()
        keep_going = true


var new_area_ref : Area3D
func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.name == "WATER_CAN_END" or area.name == "PickupableWaterCan":
        print("Should START to grow")
        if Water_Can_Ref.facing_down == true:
            print("Can's facing down too yay!")
        else: 
            print("Want to start growing but need to water")
            new_area_ref = area
            check_if_we_waterin_again = true
            return
        

func _physics_process(delta: float) -> void:
    if check_if_we_waterin_again:
        if $Area3D.overlaps_area(new_area_ref):
            if Water_Can_Ref.facing_down == true:
                print("AWESOME We're in the same area and we're watering") 
                start_the_show()
                check_if_we_waterin_again = false
            else:
                print("CRAP We're in the same area but no uisce") 

func _on_area_3d_area_exited(area: Area3D) -> void:
    if area.name == "WATER_CAN_END" or area.name == "PickupableWaterCan":
        print("Should STOP to grow")
        keep_going = false 
