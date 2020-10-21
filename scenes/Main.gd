extends Node2D
export (PackedScene) var Enemy

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$EnemyTimer.stop()
	

func new_game():
	$StartTimer.start()

func _on_StartTimer_timeout():
	$EnemyTimer.start()
	
func _on_EnemyTimer_timeout():
	# Choose a random location on Path2D.
	$EnemyPath/EnemySpawnLocation.offset = randi()
	# Create a scarecrow instance and add it to the scene.
	var scarecrow = Enemy.instance()
	add_child(scarecrow)
	# Set the scarecrow's direction perpendicular to the path direction.
	var direction = $EnemyPath/EnemySpawnLocation.rotation + PI
	# Set the mob's position to a random location.
	scarecrow.position = $EnemyPath/EnemySpawnLocation.position
	# Set the velocity (speed & direction).
	scarecrow.linear_velocity = Vector2(rand_range(scarecrow.min_speed, scarecrow.max_speed), 0)
	scarecrow.linear_velocity = scarecrow.linear_velocity.rotated(direction)
