extends CanvasLayer

signal pause_screen_selected


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(Engine.get_frames_per_second())


func _on_LevelSelectButton_button_down():
	emit_signal("pause_screen_selected")
	get_tree().change_scene("res://Scenes/UI/LevelSelect.tscn")


func _on_MenuButton_button_down():
	emit_signal("pause_screen_selected")
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
