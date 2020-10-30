extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()

func _input(ev):
	if Input.is_action_pressed("move_down"):
		get_tree().change_scene("res://scenes/Main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
