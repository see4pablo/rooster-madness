extends Control

onready var max_hearts = 3
onready var hearts = $HeartBar.get_children()

onready var dash_icon = $DashIcon.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_lives(max_hearts)
	dash_available()
	
func update_lives(number_of_lives):
	#assert(number_of_lives >= 0 and number_of_lives <= 3)
	for i in range(max_hearts):
		if(i < number_of_lives):
			hearts[i].show()
		else:
			hearts[i].hide()
			
func dash_on_cooldown():
	dash_icon.modulate = Color(0.1,0.1,0.1)
	
func dash_available():
	dash_icon.modulate = Color (1,1,1)
			

func _on_Character_lives_changed(number_of_lives):
	update_lives(number_of_lives)


func _on_Character_cooldown_started():
	dash_on_cooldown()


func _on_Character_cooldown_ended():
	dash_available()
