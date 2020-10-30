extends RigidBody2D


var life = 500
var alive = true

var linear_vel = Vector2()
var speed = 0
var min_speed = 10
var max_speed = 20
var dir = Vector2(-1,0)

var falling = false
var flaying = false
var on_floor = false

var gravity = 800
var gliding_gravity = gravity/2
var jump_friction = 0.2


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
		#if scale.y != 1:
		#	scale.y = 1
		#Enemy walk with this things
		scale.x = -dir.x
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
		#scale.y = -1
		if linear_vel.y <= gravity:
			linear_vel.y += gliding_gravity * delta * 10
		if is_on_floor():
			falling = false
			position.y = 435
			linear_vel.y = 0
			#scale.y = 1
		set_linear_velocity(linear_vel)
		

func get_hit(direction):
	direction = direction.normalized()
	var new_linear_vel = Vector2()
	if direction.x < 0:
		dir = Vector2(1,0)
		new_linear_vel = Vector2(-1,0)
	else:
		dir = Vector2(-1,0)
		new_linear_vel = Vector2(1,0)
	scale.x = -new_linear_vel.x
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
	

