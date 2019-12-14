extends Node2D
export (PackedScene) var LightStick
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var throwtimer = 0

func throw_stick(speed):
    var aimdir = $Player/Aim.rotation_degrees
    var lightStick = LightStick.instance()
    lightStick.position = $Player.position
    lightStick.apply_impulse(Vector2(0,0), Vector2(cos(deg2rad(aimdir))*(speed+0.5)*400,sin(deg2rad(aimdir))*(speed+0.5)*400))
    add_child(lightStick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("throw"):
        throwtimer += delta
        if throwtimer > 1 and throwtimer < 1000:
            throwtimer = 1000
            throw_stick(1)
        
    if Input.is_action_just_released('throw'):
        if throwtimer < 1000:
            throw_stick(throwtimer)
        throwtimer = 0
    
    if $Player.position.x > $LevelGenerator.col -50 * 50:
        $LevelGenerator.make_col()
    
