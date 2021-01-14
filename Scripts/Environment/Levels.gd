extends Node2D

signal can_teleport

var UI = preload("res://Scenes/UI/UI.tscn")

var player_scene = preload("res://Scenes/Characters/Player.tscn")
var player
var player_spawn

func _ready():
	player = player_scene.instance()
	get_tree().current_scene.add_child(player)
	get_tree().current_scene.add_child(UI.instance())
	player_spawn = get_node("PlayerSpawn").global_position
	player.position = player_spawn
	player.spawn_pos = player_spawn
	
	# Connect signal to all portals if there is more than one in a level (basically only tutorial level for now)
	for portal in get_tree().get_nodes_in_group("portals"):
		connect("can_teleport", portal, "_on_Player_can_teleport")

func _on_Player_death():
	$UI/TimerDisplay.restart_timer()
	
	print("got to level script player death signal")
	for key in get_tree().get_nodes_in_group("keys"):
		if !key.visible:
			key.visible = true
			key.collision_mask = 1

func get_num_of_Collectables():
	var num = 0
	
	for collectable in get_tree().get_nodes_in_group("collectables"):
		num += 1
	
	return num

func _on_Player_get_Collectable():
	print("get collectable in level script")
	player.collectables += 1
	print(player.collectables)
	print(get_tree().current_scene.name == "Level_1")
	if (player.get_num_of_Collectables() ==  get_num_of_Collectables()) or (get_tree().current_scene.name == "Level_1"):
		print("inside if")
		emit_signal("can_teleport")
	

