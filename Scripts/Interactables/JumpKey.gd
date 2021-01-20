extends AnimatedSprite

signal get_key

var alive

func _ready():
	alive = true
	add_to_group("keys")

func _on_Area2D_body_entered(body):
	if alive:
		emit_signal("get_key")
		SoundManager.play_se("key_pickup")
		SoundManager.set_volume_db(-40, "key_pickup")
		self.visible = false
		alive = false

