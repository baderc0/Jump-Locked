extends Area2D

func _ready():
	add_to_group("keys")
	pass

func _on_JumpKey_body_entered(body):
	body.get_key()
	self.visible = false
	self.collision_mask = 20
	#queue_free()
