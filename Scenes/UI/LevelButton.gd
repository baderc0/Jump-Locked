extends Button

signal level_button_pressed(text)

func _on_LevelButton_button_down():
	emit_signal("level_button_pressed", self.text)
