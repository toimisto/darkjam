extends KinematicBody2D

export (int) var run_speed = 300
export (int) var jump_speed = -800
export (int) var gravity = 1500

var velocity = Vector2()
var jumping = false
var direction = 1
var aimrotation = 0
var disablelight = 0
var sticks_left = 100
var landing = true
var invincible = 1000

signal take_damage


func walksound():
    if not $Land.playing:
        $Land.volume_db = -30
        $Land.pitch_scale = randf()+1
        $Land.play()

func get_input():
    velocity.x = 0
    var right = Input.is_action_pressed('right')
    var left = Input.is_action_pressed('left')
    var up = Input.is_action_pressed('up')
    var down = Input.is_action_pressed('down')
    var jump = Input.is_action_just_pressed('jump')
    var reset = Input.is_action_just_pressed('reset')
    
    if up and aimrotation > -90:
        aimrotation -= 1
    if down and aimrotation < 90:
        aimrotation += 1
    
    if jump and is_on_floor():
        jumping = true
        velocity.y = jump_speed
    if right:
        direction = 1
        velocity.x += run_speed
    if left:
        direction = -1
        velocity.x -= run_speed
    if is_on_floor() and (left or right):
        walksound()
    if reset:
        get_tree().reload_current_scene()


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
    if jumping and is_on_floor():
        jumping = false
    velocity = move_and_slide(velocity, Vector2(0, -1))
    if direction == 1:
        $Aim.rotation_degrees = aimrotation
    else:
        $Aim.rotation_degrees = 180 + (-aimrotation)
        
    for i in get_slide_count():
        var collision = get_slide_collision(i)
        if collision.collider.name == "Spikes" and invincible == 1000:
            invincible = 0
            emit_signal("take_damage")

func _process(delta):       
    if disablelight == 0:
        $PlayerLight/Light2D.hide()
        $Aim/Light2D.hide()
    if disablelight < 50:
        disablelight += 1
    if disablelight >= 50 and disablelight < 1000:
        if sticks_left > 0:
            $PlayerLight/Light2D.show()
            $Aim/Light2D.show()
            $Crackling.pitch_scale = randf()*5 +1
            $Crackling.volume_db = randf()*5
            $Crackling.play()
        disablelight = 1000
    if invincible < 50:
        if invincible%2 == 0:
            $Sprite.hide()
        else:
            $Sprite.show()
        invincible += 1
    elif invincible >= 50 and invincible < 1000:
        invincible = 1000
        
