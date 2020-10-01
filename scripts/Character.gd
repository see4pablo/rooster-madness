extends KinematicBody2D

var linear_vel = Vector2()
var speed = 500
var gravity = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	linear_vel.y += gravity
	move_and_slide(linear_vel, Vector2.UP)

	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	linear_vel.x = lerp(linear_vel.x, target_vel * speed, 0.5)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		linear_vel.y = -speed
	
