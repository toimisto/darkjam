extends Node2D
export (PackedScene) var LightStick
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var throwtimer = 0
var c = [0.0, randf(), 1.0]


func _ready():
    c.shuffle()
    $Player/PlayerLight/Light2D.color = Color(c[0],c[1],c[2],0.2)
    $Player/Aim/Light2D.color = Color(c[0],c[1],c[2],0.2)
    


func throw_stick(speed, aimdir):
    var lightStick = LightStick.instance()
    lightStick.position = $Player.position
    lightStick.apply_impulse(Vector2(0,0), Vector2(cos(deg2rad(aimdir))*(speed+0.5)*400,sin(deg2rad(aimdir))*(speed+0.5)*400))
    lightStick.stickcolor = Color(c[0],c[1],c[2],0.1)
    add_child(lightStick)
    c.shuffle()
    $Player/PlayerLight/Light2D.color = Color(c[0],c[1],c[2],0.2)
    $Player/Aim/Light2D.color = Color(c[0],c[1],c[2],0.2)
    $Player.disablelight = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("throw"):
        if $Player.disablelight == 1000:
            throwtimer += delta
            if throwtimer > 1 and throwtimer < 1000:
                throwtimer = 1000
                throw_stick(1, $Player/Aim.rotation_degrees)
        
    if Input.is_action_just_released('throw'):
        if $Player.disablelight == 1000:
            if throwtimer < 1000:
                throw_stick(throwtimer, $Player/Aim.rotation_degrees)
            throwtimer = 0
    
    if $Player.position.x > $LevelGenerator.col -50 * 50:
        $LevelGenerator.make_col()
    
