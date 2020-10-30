extends Node2D
export (PackedScene) var Enemy

# Declare member variables here. Examples:
var new_enemy_position = Vector2(500,443)
var enemies = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$EnemyTimer.stop()	

func new_game():
	go_enemy()

func go_enemy():
	$EnemyTimer.start(3) # para 3 segundos
	yield($EnemyTimer, "timeout")
	new_scarecrow()
	if enemies>0:
		go_enemy()
	
	
func new_scarecrow():
	var scarecrow = Enemy.instance()
	#var screensize = get_viewport().get_visible_rect().size
	new_enemy_position.x += 200
	scarecrow.position = new_enemy_position
	add_child(scarecrow)
	scarecrow.connect("body_entered", $Character, "_on_Enemy_body_entered")
	$Character.connect("send_me", scarecrow, "signal_hit")
	enemies -= 1
		


