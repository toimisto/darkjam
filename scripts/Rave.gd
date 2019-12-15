extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var c = [0.0, randf(), 1.0]

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    $Node2D.rotation_degrees += 1
    $Node2D2.rotation_degrees += 2
    $Node2D3.rotation_degrees -= 1
    c.shuffle()
    $Light2D2.color = Color(c[0],c[1],c[2],0.2)
    c.shuffle()
    $Light2D3.color = Color(c[0],c[1],c[2],0.2)