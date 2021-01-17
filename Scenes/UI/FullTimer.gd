extends Label

var t

var minutes
var seconds 
var miliseconds 

func _process(delta):
	t = OS.get_ticks_msec()
	minutes = int(t / 60 / 1000)
	seconds = int(t / 1000) % 60
	miliseconds = int(t) % 1000
	text = str("%02d:%02d.%03d" % [minutes, seconds, miliseconds])
	
