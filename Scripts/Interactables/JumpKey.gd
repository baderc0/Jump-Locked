extends AnimatedSprite

signal get_key

var alive

func _ready():
	alive = true
	add_to_group("keys")

func _on_Area2D_body_entered(body):
	if alive:
		emit_signal("get_key", self)

func set_alive(var val):
	if val:
		self.visible = true
		self.alive = true
	else:
		self.visible = false
		self.alive = false
	print("alive in the key yes")
