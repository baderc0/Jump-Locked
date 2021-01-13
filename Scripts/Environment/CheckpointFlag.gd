extends StaticBody2D

func _ready():
	pass 



func _on_CheckpointArea_body_entered(body):
	body.checkpoint(get_global_transform())
