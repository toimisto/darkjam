extends Node2D
export (PackedScene) var LightStick
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var throwtimer = 0
var c = [0.0, randf(), 1.0]
var meter = 0
var win = false
var death = 0


func _ready():
    c.shuffle()
    $Player/PlayerLight/Light2D.color = Color(c[0],c[1],c[2],0.2)
    $Player/Aim/Light2D.color = Color(c[0],c[1],c[2],0.2)
    $Ui/Meter.set("custom_colors/font_color", Color(c[0],c[1],c[2]))
    


func throw_stick(speed, aimdir, def):
    if $Player.sticks_left > 0:
        $Player.sticks_left -= 1
        var lightStick = LightStick.instance()
        lightStick.position = $Player.position
        lightStick.apply_impulse(Vector2(0,0), Vector2(cos(deg2rad(aimdir))*(speed+0.5)*400,sin(deg2rad(aimdir))*(speed+0.5)*400))
        lightStick.stickcolor = Color(c[0],c[1],c[2],0.1)
        lightStick.def = def
        add_child(lightStick)
        c.shuffle()
        $Player/PlayerLight/Light2D.color = Color(c[0],c[1],c[2],0.2)
        $Player/Aim/Light2D.color = Color(c[0],c[1],c[2],0.2)
        $Ui/Meter.set("custom_colors/font_color", Color(c[0],c[1],c[2]))
        $Player.disablelight = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if death > 0:
        $Player.velocity = Vector2(0, 50)
        $Player.jump_speed = 0
        $Player.run_speed = 0
        death += 1
    if death > 150:
        get_tree().reload_current_scene()
    
    if meter > 500 and not win:
        $Ui/Win.show()
        $timer.start()
        win = true
    
    meter = $Player.position.x / 50
    $Ui/Meter.text = str($Player.sticks_left) + " sticks left\n" + str(stepify(meter, 0.01)) + "m" 
    
    $Rave.volume_db = min((meter - 500)/500 * 80, 10)
    $Rave.pitch_scale = min(1-(meter - 500)/500, 1)
    
    
    if Input.is_action_pressed("throw"):
        if $Player.disablelight == 1000:
            throwtimer += delta
            if throwtimer > 1 and throwtimer < 1000:
                throwtimer = 1000
                throw_stick(1, $Player/Aim.rotation_degrees, 3)
        
    if Input.is_action_just_released('throw'):
        if $Player.disablelight == 1000:
            if throwtimer < 1000:
                throw_stick(throwtimer, $Player/Aim.rotation_degrees, 3)
            throwtimer = 0
    
    if $Player.position.x > $LevelGenerator.col -50 * 50:
        $LevelGenerator.make_col()
        
    


func _on_Player_take_damage():
    if $Player.sticks_left <= 0 and death == 0:
        death = 1
        $Rave.stop()
        $Ui/Death.show()
        $Death.play()
    else:
        var x = 100 - $Player.sticks_left
        $Hurt.play()
        for i in range(int(x*x/700-0.3*x+20)):
            throw_stick(0.5, randi()%360, 1)


func _on_timer_timeout():
    $Ui/Win.hide()
