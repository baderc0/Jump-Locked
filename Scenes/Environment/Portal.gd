extends Sprite


signal level_end

var can_teleport = false
var popup

func _ready():
	print("owner: " +owner.name)
	add_to_group("portals")
	$Label.visible = false

func _on_Area2D_body_entered(body):
	print(can_teleport)
	if can_teleport:
		owner.get_node("UI/LevelEndPopup").popup()
		SoundManager.play_se("portal")
		SoundManager.set_volume_db(-30, "portal")
		LevelChanger.load_level()
	else:
		$Label.visible = true

func _on_Player_can_teleport():
	print("reached portal signal func")
	can_teleport = true
