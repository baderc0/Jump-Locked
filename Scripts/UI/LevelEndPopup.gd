extends Popup

signal restart_button_pressed
signal next_level_button_pressed


func _on_RestartButton_pressed():
	emit_signal("restart_button_pressed")
	print("button pressed")


func _on_NextLevelButton_button_down():
	emit_signal("next_level_button_pressed")
	pass # Replace with function body.
