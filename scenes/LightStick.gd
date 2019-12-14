extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = true

func _integrate_forces(state):
    if start:
        apply_torque_impulse((randf()-0.5)*1000)
        start == false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
