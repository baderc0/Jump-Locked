extends Control

func _ready():
	pass

func _on_StartButton_button_down():
	get_tree().change_scene("res://Scenes/Levels/1-1.tscn")


func _on_LevelSelectButton_button_down():
	get_tree().change_scene("res://Scenes/UI/LevelSelect.tscn")
