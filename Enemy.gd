extends RigidBody2D


var life = 500
var alive = true

var linear_vel = Vector2()
var speed = 0
var min_speed = 10
var max_speed = 30
var dir = Vector2(-1,0)

var falling = false
var flaying = false
var on_floor = false

var gravity = 800
var gliding_gravity = gravity/2
var jump_friction = 0.2

var facing_left = true


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = rand_range(min_speed, max_speed)
	#set_gravity_scale(gravity)


func is_on_floor():
	var pos = position
	if pos.y >= 443:
		return true
	return false
	
func _physics_process(delta):
	on_floor = is_on_floor()
	
	if not falling and not flaying:
		if facing_left and dir.x == 1:
			facing_left = false
			scale.x = -1
		elif (not facing_left) and dir.x == -1:
			facing_left = true
			scale.x = -1
		#Enemy walk with this things
		$AnimatedSprite.animation = "walk"
		linear_vel = dir * speed
		set_linear_velocity(linear_vel)
	
	if flaying:
		set_friction(jump_friction)
		linear_vel.y += gliding_gravity * delta * 10
		set_linear_velocity(linear_vel)
		var vel = get_linear_velocity()
		if vel.y >= 0:
			flaying = false
			falling = true
			#$AnimatedSprite.animation = "falling"
	
	if falling:
		if linear_vel.y <= gravity:
			linear_vel.y += gliding_gravity * delta * 10
		if is_on_floor():
			falling = false
			position.y = 435
			linear_vel.y = 0
		set_linear_velocity(linear_vel)
		

func get_hit(direction):
	direction = direction.normalized()
	var new_linear_vel = Vector2()
	if direction.x < 0:
		if facing_left:
			facing_left = false
			scale.x = -1
		dir = Vector2(1,0)
		new_linear_vel = Vector2(-1,0)
	else:
		if not facing_left:
			facing_left = true 
			scale.x = -1
		dir = Vector2(-1,0)
		new_linear_vel = Vector2(1,0)
	new_linear_vel.x = new_linear_vel.x*500
	new_linear_vel.y = -gravity/2
	linear_vel = new_linear_vel
	set_linear_velocity(linear_vel)
	$AnimatedSprite.animation = "get_hit"
	flaying = true
	falling = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#apply_gravity(delta)
	pass

		
func signal_hit(vector):
	get_hit(vector)
	

