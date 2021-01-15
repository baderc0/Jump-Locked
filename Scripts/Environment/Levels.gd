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
	
	# UI stuff
	$UI/LevelLabel/Label.text = str(int(get_tree().current_scene.name))
	
	# Connect signal to all portals if there is more than one in a level (basically only tutorial level for now)
	for portal in get_tree().get_nodes_in_group("portals"):
		connect("can_teleport", portal, "_on_Player_can_teleport")

func _on_Player_death():
	$UI/TimerDisplay.restart_timer()
	player.collectables = 0
	
	print("got to level script player death signal")
	# Respawn keys
	for key in get_tree().get_nodes_in_group("keys"):
		if !key.visible:
			key.visible = true
			key.get_node("Area2D").set_collision_mask_bit(0, true)
	
	# Respawn Collectables
	for star in get_tree().get_nodes_in_group("collectables"):
		if !star.visible:
			star.visible = true
			star.get_node("Area2D").set_collision_mask_bit(0, true)

func get_num_of_Collectables():
	var num = 0
	
	for collectable in get_tree().get_nodes_in_group("collectables"):
		num += 1
	
	return num

func _on_Player_get_Collectable():
	if (player.get_num_of_Collectables() ==  get_num_of_Collectables()) or (get_tree().current_scene.name == "Level_1"):
		print("inside if")
		emit_signal("can_teleport")
	

