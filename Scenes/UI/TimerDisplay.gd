extends RichTextLabel

var minutes = 0
var seconds = 0
var ms = 0

func _process(delta):

	if ms > 9:
		seconds += 1
		ms = 0
	
	if seconds > 59:
		minutes += 1
		seconds = 0

	set_text("%02d:%02d.%02d" % [minutes, seconds, ms])


func _on_Timer_timeout(): 
	ms += 1

func restart_timer():
	minutes = 0
	seconds = 0
	ms = 0
