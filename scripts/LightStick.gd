extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = true
var stickcolor
var def = 3
var sleep = 0

func _integrate_forces(state):
    if start:
        apply_torque_impulse((randf()-0.5)*50)
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
    if def == 1:
        $Lightonstick1.queue_free()
        $Lightonstick3.queue_free()
    elif def == 2:
        $Lightonstick2.queue_free()

    


func _on_Node2D_body_entered(body):
    if body.name == "BlockBody":
        var vel = get_linear_velocity()
        if sqrt(vel.x*vel.x + vel.y*vel.y) > 10:
            $Crackling.volume_db = -50 + (20* log(min(300, sqrt(vel.x*vel.x + vel.y*vel.y)))/log(10))
            $Crackling.pitch_scale = randf()*4+2
            $Crackling.play()