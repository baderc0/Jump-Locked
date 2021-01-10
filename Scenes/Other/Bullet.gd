extends Area2D

var speed = Vector2(500, 0)
var direction = 1

func _ready():
	pass 

func change_dir(dir):
	direction = dir

func _process(delta):
	position += speed * delta * direction
