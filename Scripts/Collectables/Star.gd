extends Sprite

func _ready():
	add_to_group("collectables")
	$Area2D.set_collision_mask_bit(1, true)
	pass 

func _on_Area2D_body_entered(body):
	SoundManager.play_se("collectable_pickup")
	SoundManager.set_volume_db(-40, "collectable_pickup")
	body.get_collectable()
	self.visible = false
	$Area2D.set_collision_mask_bit(0, false)
