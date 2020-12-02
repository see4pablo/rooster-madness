extends KinematicBody2D

var LEFT = -1
var RIGHT = 1

var velocity = Vector2()
export var direction = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true


func _physics_process(delta):
	
	if is_on_wall():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	velocity.y += 20 
	
	velocity.x = 50*direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
