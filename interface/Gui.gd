extends Control

onready var max_hearts = 3
onready var heart_1 = $MarginContainer/NinePatchRect/Heart_1
onready var heart_2 = $MarginContainer/NinePatchRect/Heart_2
onready var heart_3 = $MarginContainer/NinePatchRect/Heart_3
onready var hearts = [heart_1, heart_2, heart_3]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_lives(max_hearts)
	
func update_lives(number_of_lives):
	assert(number_of_lives >= 0 and number_of_lives <= 3)
	for i in range(max_hearts):
		if(i < number_of_lives):
			hearts[i].show()
		else:
			hearts[i].hide()
			
		
	
	
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Character_lives_changed(number_of_lives):
	update_lives(number_of_lives)
