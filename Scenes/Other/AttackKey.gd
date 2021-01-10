extends Area2D

func _ready():
	pass

func _on_AttackKey_body_entered(body):
	print("got key!")
	body.get_key()
	queue_free()
