extends KinematicBody2D

# vars to edit when change enemy type:
var life = 200
var character_speed = 1
export var search_rad = 300
#------------------------------------
# States
var actual_state = idle
var idle = 1
var getting_hit = 2
#------------------------------------

var LEFT = -1
var RIGHT = 1

var velocity = Vector2()
var move_speed = character_speed * Globals.UNIT_SIZE
var gravity = 20
export var direction = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$player_checker_left.cast_to.x = search_rad * -1
	$player_checker_right.cast_to.x = search_rad
	

func player_detected():
	return $player_checker_left.is_colliding() or $player_checker_right.is_colliding()


func _physics_process(delta):
	
	if player_detected():
		if $player_checker_left.is_colliding():
			direction = LEFT
			$AnimatedSprite.flip_h = false
		else:
			direction = RIGHT
			$AnimatedSprite.flip_h = true
	elif is_on_wall(): # uso elif porque la cond anterior es prioridad sobre esta
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	velocity.y += gravity 
	
	velocity.x = move_speed*direction
	
	velocity = move_and_slide(velocity, Vector2.UP)


func get_hit(damage):
	if actual_state == getting_hit:
		return
	$Receive_hit.start(0.5)
	life -= damage
	actual_state = getting_hit
	if life <= 0:
		# ToDo: change sprite to "die"
		$AnimatedSprite.play("die")
		move_speed = 0
		set_collision_layer_bit(5, false)
		set_collision_mask_bit(0, false)
		$hit_checker.set_collision_layer_bit(5, false)
		$hit_checker.set_collision_mask_bit(0, false)
		$Timer.start()
	else:
		# ToDo: change sprite to "getHit"
		$AnimatedSprite.play("getHit")


func _on_hit_checker_body_entered(body):
	if body.is_class("KinematicBody2D") and body.has_method("get_attacked"):
		body.get_attacked(self)
					
	elif body.is_class("StaticBody2D"):
		get_hit(100)


func _on_Timer_timeout():
	queue_free() # enemy die


func _on_Receive_hit_timeout():
	actual_state = idle
