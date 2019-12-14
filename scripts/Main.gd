extends Node2D
export (PackedScene) var LightStick
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    var lightStick = LightStick.instance()
    lightStick.position = $Player.position
    add_child(lightStick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if $Player.position.x > $LevelGenerator.col -50 * 50:
        $LevelGenerator.make_col()
    
