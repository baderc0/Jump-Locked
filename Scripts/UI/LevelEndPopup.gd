extends Popup

signal restart_button_pressed


func _on_RestartButton_pressed():
	emit_signal("restart_button_pressed")
	print("button pressed")
