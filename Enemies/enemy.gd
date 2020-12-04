extends KinematicBody2D

# vars to edit when change enemy type:
var character_speed = 1
export var search_rad = 300
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
	


func _on_top_checker_body_entered(body):
	$AnimatedSprite.play("squashed")
	move_speed = 0
	set_collision_layer_bit(5, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(5, false)
	$top_checker.set_collision_mask_bit(0, false)
