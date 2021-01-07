extends Node



func _ready():
	 $MarginContainer/VBoxContainer/TextureButton.grab_focus()



func _physics_process(delta):
	pass




func _on_TextureButton_pressed():
	get_tree().change_scene("res://Game.tscn")
