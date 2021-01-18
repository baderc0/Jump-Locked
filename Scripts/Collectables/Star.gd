extends AnimatedSprite

signal get_collectable

func _ready():
	add_to_group("collectables")
	$Area2D.set_collision_mask_bit(0, true)

func _on_Area2D_body_entered(body):
	emit_signal("get_collectable")
	SoundManager.play_se("collectable_pickup")
	SoundManager.set_volume_db(-40, "collectable_pickup")
	self.visible = false
	$Area2D.set_collision_mask_bit(0, false)
