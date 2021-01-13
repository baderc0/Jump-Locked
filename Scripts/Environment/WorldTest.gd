extends Node2D

var player_scene = preload("res://Scenes/Characters/Player.tscn")
onready var target_level = get_node("Level_1")

func _ready():
	connect("tree_exited", self, "_on_tree_entered")
	
	# Put player at the start of the first level
	var player = player_scene.instance()
	target_level.add_child(player)
	player.global_position = get_node("Level_1/PlayerSpawn").global_position
	
func _on_tree_entered():
	print("the scene has changed! it has!")

func place_player():
	var player = player_scene.instance()
	target_level.add_child(player)
	player.global_position = get_node("Level_2/PlayerSpawn").global_position
	pass
	

