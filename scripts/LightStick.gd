extends KinematicBody2D

export (int) var gravity = 1500

var velocity = Vector2()

func _ready():
    velocity.y =+ -500
    velocity.x =+ 200

func _physics_process(delta):
    velocity.y += gravity * delta
    velocity = move_and_slide(velocity, Vector2(0, -1))