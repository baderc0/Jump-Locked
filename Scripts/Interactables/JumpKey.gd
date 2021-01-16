extends Sprite

signal get_key

func _ready():
	add_to_group("keys")
	$Area2D.set_collision_mask_bit(0, true)

func _on_Area2D_body_entered(body):
	emit_signal("get_key")
	SoundManager.play_se("key_pickup")
	SoundManager.set_volume_db(-30, "key_pickup")
	self.visible = false
	$Area2D.set_collision_mask_bit(0, false)
