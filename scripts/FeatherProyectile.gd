extends KinematicBody2D

const THROW_VELOCITY = Vector2(800, -400)

var velocity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

func launch(direction):
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	velocity = THROW_VELOCITY * Vector2(direction)
	set_physics_process(true)

func _on_impact(normal : Vector2):
	pass
	
