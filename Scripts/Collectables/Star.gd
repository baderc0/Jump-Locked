extends Sprite

func _ready():
	pass 

func _on_Area2D_body_entered(body):
	print("Character got a star!")
	queue_free()
