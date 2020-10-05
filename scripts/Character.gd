extends KinematicBody2D

var linear_vel = Vector2()
var target_vel = Vector2()
var mouse_target = Vector2()
var speed = 300
var dash_speed = speed * 3
var gravity = 500
var falling_gravity = gravity

#booleans of state
var facing_right = true
var falling = true
var dashing = false
var can_dash = false
var on_floor = false

onready var playback = $AnimationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func rooster_killed():
	#things that happen if the hero killed an enemy
	can_dash = true

func _physics_process(delta):
	
	linear_vel.y += falling_gravity * delta	
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	
	on_floor = is_on_floor()
	if on_floor: 
		can_dash = true
		dashing = false
	
	#input
	
	#horizontal movement
	target_vel.x = 0
	target_vel.y = 0
	falling_gravity = gravity
	
	if not dashing:		
		
		if Input.is_action_pressed("move_right"):
			target_vel.x += speed
		if Input.is_action_pressed("move_left"):
			target_vel.x -= speed
		#jumping and gliding
		if Input.is_action_pressed("jump"):
			if on_floor:
				linear_vel.y = -speed
			else:
				#gliding
				falling_gravity = 0.5*gravity
		if can_dash and Input.is_action_just_pressed("left_click"):
			can_dash = false
			dashing = true
			mouse_target = get_global_mouse_position()
			linear_vel = (mouse_target - position).normalized() * dash_speed 

		linear_vel.x = lerp(linear_vel.x, target_vel.x, 0.5)
	
	linear_vel.y += target_vel.y
	
	if dashing:
		#dash a certain distance, ignoring gravity and friction
		
		pass
	
	#animation
	if on_floor:
		if linear_vel.length_squared() > 10:
			playback.travel("walk")
		else:
			playback.travel("idle")	 
	else:
		if linear_vel.y > 0:
			playback.travel("fall")
		elif linear_vel.y < 0:
			playback.travel("jump")
			
	if facing_right and linear_vel.x < 0:
		scale.x = -1
		facing_right = false
	if not facing_right and linear_vel.x > 0:
		scale.x = -1
		facing_right = true
		
	if falling and linear_vel.y <= 0:
		falling = false
	if not falling and linear_vel.y > 0:
		falling = true
