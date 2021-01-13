extends Node2D

var player_scene = preload("res://Scenes/Characters/Player.tscn")
var player
var player_spawn

func _ready():
	player = player_scene.instance()
	get_tree().current_scene.add_child(player)
	player_spawn = get_node("PlayerSpawn").global_position
	player.position = player_spawn
	player.spawn_pos = player_spawn

