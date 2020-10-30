extends KinematicBody2D

var linear_vel = Vector2()
var target_vel = Vector2()
var mouse_target = Vector2()
var origin_for_dash = Vector2()

var gravity = 800
var gliding_gravity = gravity/2

var speed = 300

var jump_speed = 3*speed/2

var dash_speed = speed * 6
var dash_distance = 3*speed/4

#booleans of state
var facing_right = true
var falling = true
var dashing = false
var can_dash = false
var waiting_cooldown = false
var on_floor = false
var gliding = false
var receiving_hit = false
#ints of state
var lives = 3

signal send_me(me)
signal lives_changed(number_of_lives)
signal dead()

onready var playback = $AnimationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = 3
	can_dash = true

func rooster_killed_enemy():
	#things that happen if the hero killed an enemy
	can_dash = true

func reduce_lives():
	lives -= 1
	emit_signal("lives_changed",lives)
	if(lives <= 0):
		emit_signal("dead")
	
func rooster_hit_enemy():
	#things that happen if the hero hit an enemy:
	#attack! and short jump above the enemy
	dashing = false
	linear_vel.x = 0
	linear_vel.y = -speed
	
func rooster_get_hit():
	receiving_hit = true
	var new_linear_vel = Vector2(1,-gliding_gravity/2)
	if facing_right:
		new_linear_vel.x = -1
	new_linear_vel.x = new_linear_vel.x*100
	linear_vel = new_linear_vel
	reduce_lives()
	

func apply_gravity(delta):
	if not dashing:
		if gliding: 
			linear_vel.y += gliding_gravity * delta
		else:
			linear_vel.y += gravity * delta	
			
			


func _physics_process(delta):
	on_floor = is_on_floor()
	if on_floor: 
		if falling:
			$Cooldown.start(3)
			$Cooldown.connect("timeout", self, "_on_Cooldown_timeout")
			can_dash = false
			waiting_cooldown = true
		if not waiting_cooldown:
			can_dash = true
		dashing = false
		
		#yield($Cooldown, "timeout")
	
	#input
	
	if receiving_hit and on_floor and linear_vel.y>=0:
		linear_vel.y = 0
		linear_vel.x = 0
		receiving_hit = false
		
	#horizontal movement
	target_vel.x = 0
	target_vel.y = 0
	gliding = false
	
	if not dashing and not receiving_hit:		
		
		if Input.is_action_pressed("move_right"):
			target_vel.x += speed
		if Input.is_action_pressed("move_left"):
			target_vel.x -= speed
		#jumping and gliding
		if Input.is_action_pressed("jump"):
			if on_floor:
				linear_vel.y = -jump_speed
				
			else:
				if falling:
					#gliding
					gliding = true
		if can_dash and Input.is_action_just_pressed("left_click"):
			can_dash = false
			dashing = true
			origin_for_dash = position
			mouse_target = get_global_mouse_position()
			linear_vel = (mouse_target - origin_for_dash).normalized() * dash_speed 

		linear_vel.x = lerp(linear_vel.x, target_vel.x, 0.5)
		linear_vel.y += target_vel.y
	
	if dashing:
		#dash a certain distance, ignoring gravity and friction
		if position.distance_to(origin_for_dash) >= dash_distance:
			dashing = false
			linear_vel.x = 0;
			linear_vel.y = 0;	
		
	
	#animation
	if dashing:
		playback.travel("dash")
	else:	
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
		
	apply_gravity(delta)
	linear_vel = move_and_slide(linear_vel, Vector2.UP)

func _on_Enemy_body_entered(body):
	if dashing:
		emit_signal("send_me", linear_vel)
		rooster_hit_enemy()
	else: 
		rooster_get_hit()



func _on_Cooldown_timeout():
	can_dash = true
	waiting_cooldown = false
