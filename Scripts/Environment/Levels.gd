extends Node2D

var player_scene = preload("res://Scenes/Characters/Player.tscn")
var player

func _ready():
	player = player_scene.instance()
	get_tree().current_scene.add_child(player)
	player.position = get_node("PlayerSpawn").global_position

