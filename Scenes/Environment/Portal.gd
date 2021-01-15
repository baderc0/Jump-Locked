extends Sprite


signal level_end

var can_teleport = false

func _ready():
	print("owner: " +owner.name)
	add_to_group("portals")
	$Label.visible = false

func _on_Area2D_body_entered(body):
	print(can_teleport)
	if can_teleport:
		LevelChanger.show_level_end()
		SoundManager.play_se("portal")
		SoundManager.set_volume_db(-30, "portal")
		
	else:
		$Label.visible = true

func _on_Player_can_teleport():
	print("reached portal signal func")
	can_teleport = true
