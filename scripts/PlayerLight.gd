extends Node2D

var disable = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if disable == 0:
        $Light2D.hide()
    if disable < 100:
        disable += 1
    if disable >= 100 and disable < 1000:
        $Light2D.show()
        disable = 1000
