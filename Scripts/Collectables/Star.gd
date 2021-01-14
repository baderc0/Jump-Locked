extends Sprite

signal player_get_collectable

func _ready():
	connect("player_get_collectable", self.owner, "_on_Player_get_Collectable")
	add_to_group("collectables")
	pass 

func _on_Area2D_body_entered(body):
	emit_signal("player_get_collectable")
	print("Character got a star!")
	queue_free()
