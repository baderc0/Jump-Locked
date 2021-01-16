extends Sprite


signal portal_touched

var can_teleport = false

func _ready():
	add_to_group("portals")
	$Label.visible = false

func _on_Area2D_body_entered(body):
	emit_signal("portal_touched")

func _on_Player_can_teleport():
	print("reached portal signal func")
	can_teleport = true
