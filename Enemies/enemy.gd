extends KinematicBody2D

# vars to edit when change enemy type:
var life = 400
var character_speed = 1
export var search_rad = 300
#------------------------------------
# States
var idle = true
var facing_right = true
var getting_hit = false
var jumping = false
#------------------------------------
const UP = Vector2(0, -1)
const SLOPE_STOP = 64


var velocity = Vector2()
var move_speed = character_speed * Globals.UNIT_SIZE
var gravity = 20
export var direction = -1

onready var checker_left = $player_checker_left
onready var checker_right = $player_checker_right
onready var anim_sprite = $Body/AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	checker_left.cast_to.x = search_rad * -1
	checker_right.cast_to.x = search_rad

func _apply_gravity(delta):
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


func _jump():
	jumping = true
	velocity.x = move_speed*(direction*-1)*50
	velocity.y = gravity*(-1)*60
	velocity = move_and_slide(velocity)
	

func get_hit(damage):
	if getting_hit:
		return false
	$Receive_hit.start(0.5)
	life -= damage
	getting_hit = true
	idle = false
	if life <= 0:
		$AnimatedSprite.play("die")
		move_speed = 0
		set_collision_layer_bit(5, false)
		set_collision_mask_bit(0, false)
		$hit_checker.set_collision_layer_bit(5, false)
		$hit_checker.set_collision_mask_bit(0, false)
		$Timer.start()
		return true
	else:
		_jump()
		anim_sprite.play("getHit")
		return false


func _on_hit_checker_body_entered(body):
	if jumping:
		return
	if body.is_class("KinematicBody2D") and body.has_method("get_attacked"):
		body.get_attacked(self)
					
	elif body.is_class("StaticBody2D"):
		get_hit(100)


func _on_Timer_timeout():
	queue_free() # enemy die


func _on_Receive_hit_timeout():
	getting_hit = false
