extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = true
var stickcolor

func _integrate_forces(state):
    if start:
        apply_torque_impulse((randf()-0.5)*1000)
        start == false

# Called when the node enters the scene tree for the first time.
func _ready():
    $Lightonstick1.color = stickcolor
    $Lightonstick2.color = stickcolor
    $Lightonstick3.color = stickcolor
    $ColorRect.color = stickcolor
    $ColorRect.color.a = 1
    $ColorRect.color.r += 0.6 
    $ColorRect.color.b += 0.6 
    $ColorRect.color.g += 0.6 


