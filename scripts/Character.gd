extends KinematicBody2D

var linear_vel = Vector2()
var speed = 300
var gravity = 400
var facing_right = true
var facing_up = true

onready var playback = $AnimationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	linear_vel.y += gravity * delta
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	
	var on_floor = is_on_floor()

	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	linear_vel.x = lerp(linear_vel.x, target_vel * speed, 0.5)
	
	if Input.is_action_just_pressed("jump") and on_floor:
		linear_vel.y = -speed
	
	#animation
	print(linear_vel.length_squared())
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
			
	if facing_right and target_vel < 0:
		scale.x = -1
		facing_right = false
	if not facing_right and target_vel > 0:
		scale.x = -1
		facing_right = true
		
			
	
