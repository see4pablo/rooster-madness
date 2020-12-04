extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOPE_STOP = 64

var gravity
var gliding_gravity
var max_jump_velocity
var min_jump_velocity

# conditions to check
var facing_right = true
var glide_cond = false
var dash_cond = false

var max_jump_height = 2.25 * Globals.UNIT_SIZE
var min_jump_height = 0.8 * Globals.UNIT_SIZE
var jump_duration = 0.5

var velocity = Vector2()
var move_speed = 5 * Globals.UNIT_SIZE

var dash_speed = 4 * move_speed
var dash_origin = Vector2()
var mouse_target = Vector2()
var dash_distance = 5 * Globals.UNIT_SIZE

onready var raycasts = $Raycasts
onready var anim_player = $AnimationPlayer
onready var state_info = $Player_UI/State_Info

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	gliding_gravity = gravity/4
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	
	Globals.player = self
	
func _apply_gravity(delta):
	if glide_cond:
		velocity.y += gliding_gravity * delta
	else:
		velocity.y += gravity * delta
		
	
func _apply_movement(delta):
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	_handle_facing()
	
func _handle_facing():
	
	if(velocity.x > 0 and facing_right == false):
		facing_right = true
		$Body.scale.x = 1
	elif(velocity.x < 0 and facing_right == true):
		facing_right = false
		$Body.scale.x = -1
	
		
func _handle_move_input():
	
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	
func _get_h_weight():
	return 0.2 if is_on_floor() else 0.1
	
func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	
	#if loop was completed then raycast was not detected	
	return false

