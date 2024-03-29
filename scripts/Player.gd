extends KinematicBody2D

export (int) var run_speed = 300
export (int) var jump_speed = -800
export (int) var gravity = 1500

var velocity = Vector2()
var jumping = false
var direction = 1
var aimrotation = 0
var sticks_left = 100
var landing = true

signal take_damage


func walksound():
    if not $Land.playing:
        $Land.volume_db = -30
        $Land.pitch_scale = randf()+1
        $Land.play()

func get_input():
    velocity.x = velocity.x/7
    var right = Input.is_action_pressed('right')
    var left = Input.is_action_pressed('left')
    var up = Input.is_action_pressed('up')
    var down = Input.is_action_pressed('down')
    var jump = Input.is_action_just_pressed('jump')
    var air = Input.is_action_pressed('jump')
    
    if up and aimrotation > -90:
        aimrotation -= 1
    if down and aimrotation < 90:
        aimrotation += 1
    
    if jump and is_on_floor():
        jumping = true
        velocity.y = jump_speed
    if jumping and air:
        velocity.y -= 16 * abs(velocity.y/jump_speed) # make player float a bit when button hold
    if right:
        direction = 1
        velocity.x += min(velocity.x + run_speed*0.7,run_speed) #small acceleration
    if left:
        direction = -1
        velocity.x -= min(abs(velocity.x) + run_speed*0.7,run_speed) #small acceleration
    if is_on_floor() and (left or right):
        walksound()


func _physics_process(delta):
    get_input()
    if is_on_floor() and landing:
        $Land.volume_db = -20
        $Land.pitch_scale = randf()+1
        $Land.play()
        landing = false
    if not is_on_floor():
        landing = true
    velocity.y += gravity * delta
    if jumping and is_on_floor() and velocity.y > 0:
        jumping = false
    velocity = move_and_slide(velocity, Vector2(0, -1))
    if direction == 1:
        $Aim.rotation_degrees = aimrotation
    else:
        $Aim.rotation_degrees = 180 + (-aimrotation)
        
    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider.name == "Spikes" and $Invincible.time_left == 0:
            $Invincible.start()
            emit_signal("take_damage")

func _process(delta):    
    if $Invincible.time_left > 0:
        if int($Invincible.time_left * 10)%2 == 0:   
            $Sprite.show()
        else:
            $Sprite.hide()
        


func _on_ThrowCooldown_timeout():
    if sticks_left > 0:
        $PlayerLight/Light2D.show()
        $Aim/Light2D.show()
        $Crackling.pitch_scale = randf()*5 +1
        $Crackling.volume_db = randf()*5
        $Crackling.play()
