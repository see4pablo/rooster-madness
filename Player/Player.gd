extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOPE_STOP = 64

var velocity = Vector2()
var move_speed = 5 * Globals.UNIT_SIZE
var gravity
var max_jump_velocity
var min_jump_velocity
var is_grounded = false

var max_jump_height = 2.25 * Globals.UNIT_SIZE
var min_jump_height = 0.8 * Globals.UNIT_SIZE
var jump_duration = 0.5

onready var raycasts = $Raycasts

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	
	Globals.player = self
	
func _apply_gravity(delta):
	velocity.y += gravity * delta
	
func _apply_movement(delta):
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	is_grounded = _check_is_grounded()
	print(is_grounded)
	_assign_animation()
	
		
func _handle_move_input():
	
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	
func _get_h_weight():
	return 0.2 if is_grounded else 0.1
	
func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	
	#if loop was completed then raycast was not detected	
	return false

func _assign_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"
	elif velocity.x != 0:
		anim = "walk"
		
	#if anim_player.assigned_animation != anim:
	#	anim_player.play(anim)
