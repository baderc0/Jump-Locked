extends Sprite

func _ready():
	pass 

func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://Scenes/Levels/Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
	print("touched portal!")
