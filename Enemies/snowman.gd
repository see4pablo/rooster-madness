extends KinematicBody2D

# vars to edit when change enemy type:
var life = 100
var character_speed = 1
export var search_rad = 300
#------------------------------------
# States
var idle = true
var facing_right = false
var getting_hit = false
var jumping = false
#------------------------------------
const UP = Vector2(0, -1)
const SLOPE_STOP = 64


var velocity = Vector2()
var move_speed = character_speed * Globals.UNIT_SIZE
var gravity = 20 * move_speed

onready var checker_left = $player_checker_left
onready var checker_right = $player_checker_right
onready var anim_sprite = $Body/AnimatedSprite
onready var state_info = $Enemy_UI/State_Info
onready var enemyFSM = $StateMachine
onready var damage_cooldown = $Receive_hit
onready var dead_timer = $Timer
onready var life_info = $Enemy_UI/Life_Info

# Called when the node enters the scene tree for the first time.
func _ready():
	checker_left.cast_to.x = search_rad * -1
	checker_right.cast_to.x = search_rad
	life_info.text = str(life)

func _apply_gravity(delta):
	velocity.y += gravity * delta

func _apply_movement(delta):
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	_handle_facing()


func _handle_facing():

	if(velocity.x > 0 and facing_right == false):
		facing_right = true
		$Body.scale.x = -1
	elif(velocity.x < 0 and facing_right == true):
		facing_right = false
		$Body.scale.x = 1


func _jump():
	jumping = true
	var direction = -1
	if facing_right: direction = 1
	velocity.x = move_speed*(direction*-1)
	velocity.y = move_speed*(-1)
	

func receive_hit(damage):

	life -= damage
	life_info.text = str(life)
	$Receive_hit.start(2)
	_jump()
	
		
	return enemyFSM._receive_hit()

func _is_dead():
	return life <= 0

func _on_dead():

	set_collision_layer_bit(5, false)
	set_collision_mask_bit(0, false)
	$hit_checker.set_collision_layer_bit(5, false)
	$hit_checker.set_collision_mask_bit(0, false)


func _on_hit_checker_body_entered(body):
	enemyFSM._on_hit_checker_body_entered(body)


func _on_Timer_timeout():
	queue_free() # enemy die


func _on_Receive_hit_timeout():
	enemyFSM._on_Receive_hit_timeout()
