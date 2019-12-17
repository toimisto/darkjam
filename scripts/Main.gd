extends Node2D
export (PackedScene) var LightStick
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var throwtimer = 0
var c = [0.0, randf(), 1.0]
var meter = 0
var win = false
var sticks = []

var rave = 500


func _ready():
    get_tree().paused = false
    randomize()
    c.shuffle()
    $Player/PlayerLight/Light2D.color = Color(c[0],c[1],c[2],0.2)
    $Player/Aim/Light2D.color = Color(c[0],c[1],c[2],0.2)
    $Ui/Meter.set("custom_colors/font_color", Color(c[0],c[1],c[2]))
    


func throw_stick(speed, aimdir, def, front):
    if $Player.sticks_left > 0:
        $ThrowCooldown.start()
        $Player.sticks_left -= 1
        var lightStick = LightStick.instance()
        lightStick.position = $Player.position
        lightStick.apply_impulse(Vector2(0,0), Vector2(cos(deg2rad(aimdir))*(speed+0.5)*400,sin(deg2rad(aimdir))*(speed+0.5)*400))
        lightStick.stickcolor = Color(c[0],c[1],c[2],0.1)
        lightStick.def = def
        add_child(lightStick)
        if front:
            sticks.push_front(lightStick)
        else:
            sticks.push_back(lightStick)
        c = [0.0, randf(), 1.0]
        c.shuffle()
        $Player/PlayerLight/Light2D.hide()
        $Player/Aim/Light2D.hide()
        $Player/PlayerLight/Light2D.color = Color(c[0],c[1],c[2],0.2)
        $Player/Aim/Light2D.color = Color(c[0],c[1],c[2],0.2)
        $Ui/Meter.set("custom_colors/font_color", Color(c[0],c[1],c[2]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):    
    if delta > 0.018 and sticks.size() > 10: #kill off extra sticks if lagging
        sticks[0].queue_free()
        sticks.pop_front()
    
    
    if meter > 500 and not win:
        $Ui/Win.show()
        $Winshow.start()
        win = true
    
    meter = $Player.position.x / 50 +25
    $Ui/Meter.text = str($Player.sticks_left) + " sticks left\n" + str(stepify(meter, 0.01)) + "m\n"
        
    var dp = 1-abs(meter - (rave+10))/(rave+10) # distance %
    AudioServer.get_bus_effect(1,0).cutoff_hz = min(max((pow(50, 10 * dp -10) + dp/80) * 20000, 1), 20000) # change stopband filttering
    
    if Input.is_action_just_pressed("throw") and $Throw.time_left == 0 and $ThrowCooldown.time_left == 0:
        $Throw.start()

                
    
    if Input.is_action_just_released('throw') and $Throw.time_left > 0 and $ThrowCooldown.time_left == 0:
        throw_stick(1 - $Throw.time_left, $Player/Aim.rotation_degrees, 3, false)
        $Throw.stop()
            
    if Input.is_action_just_pressed('reset'):
        get_tree().reload_current_scene()
        
    while $Player.position.x > ($LevelGenerator.col -100) * 50:
        $LevelGenerator.make_col()
        
    


func _on_Player_take_damage():
    if $Player.sticks_left <= 0 and $DeathTime.time_left == 0:
        $DeathTime.start()
        $Rave.stop()
        if not win:
            $Ui/Death.text = "R.I.P\nYou did not get to the party but\nyou got " + str(stepify(meter, 0.01)) + " meters in to the cave"
        else:
            $Ui/Death.text = "R.I.P\nYou should have stayed at the party!\nYou got " + str(stepify(meter, 0.01)) + " meters in to the cave"
        $Ui/Death.show()
        $Death.play()
        get_tree().paused = true
    else:
        var x = 100 - $Player.sticks_left
        $Hurt.play()
        for i in range(int(x*x/700-0.3*x+20)):
            if i%2 == 0:
                throw_stick(0.5, randi()%360, 1, true) # Put half of the sticks to be killed off first.
            else:
                throw_stick(0.5, randi()%360, 1, false)


func _on_timer_timeout():
    $Ui/Win.hide()


func _on_Throw_timeout():
    throw_stick(1, $Player/Aim.rotation_degrees, 3, false)


func _on_DeathTime_timeout():
    get_tree().reload_current_scene()
