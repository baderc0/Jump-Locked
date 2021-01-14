extends Sprite

var can_teleport = false

func _ready():
	add_to_group("portals")

func _on_Area2D_body_entered(body):
	
	print(can_teleport)
	if can_teleport:
		LevelChanger.load_level()
	else:
		print("You can't yet! Need to collect all the collectables first lel")

func _on_Player_can_teleport():
	print("reached portal signal func")
	can_teleport = true
