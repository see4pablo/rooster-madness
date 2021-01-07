extends Node



func _ready():
	MusicController.play_music()
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()



func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered()==true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
		
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered()==true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()
	


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Game.tscn")


func _on_TextureButton2_pressed():
	get_tree().change_scene("res://credits.tscn")
