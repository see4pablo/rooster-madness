extends RigidBody2D


export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = "walk"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
