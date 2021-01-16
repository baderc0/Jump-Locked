extends Node2D

signal can_teleport

var current_level


var player_scene = preload("res://Scenes/Player/Player.tscn")
var player

export var next_scene: String

var UI_scene  = preload("res://Scenes/UI/UI.tscn")
var UI

var num_of_collectables = 0

func _ready():
	print(next_scene)
	for collectable in get_tree().get_nodes_in_group("collectables"):
		num_of_collectables += 1
	
	current_level = int(name)
	player = player_scene.instance()
	player.global_position = $PlayerSpawn.position
	
	UI = UI_scene.instance()
	UI.get_node("LevelLabel/Label").text = str(current_level)
	
	add_child(player)
	add_child(UI)
	
	print("total num of stars: " + str(num_of_collectables))
	
	#Signal connections
	for key in get_tree().get_nodes_in_group("keys"):
		key.connect("get_key", self, "_on_get_JumpKey")
		
	for collectable in get_tree().get_nodes_in_group("collectables"):
		collectable.connect("get_collectable", self, "_on_get_Collectable")

	$Interactables/Portals/Portal.connect("portal_touched", self, "_on_Portal_touched")
	$Player.connect("player_death", self, "_on_Player_death")
	$Player.connect("player_restart", self, "_on_Player_restart")
	
	# Connect signal to all portals if there is more than one in a level (basically only tutorial level for now)
	#for portal in get_tree().get_nodes_in_group("portals"):
		#connect("can_teleport", s, "_on_Player_can_teleport")

func _on_get_JumpKey():
	print("you got a key")
	$Player.is_unlocked = true

func _on_get_Collectable():
	$Player.collectables += 1
	print(str($Player.collectables))

func _on_Portal_touched():
	if $Player.collectables == num_of_collectables:
		if next_scene != "":
			print("next scene is not null")
			get_tree().change_scene(next_scene)
		else:
			print("next scene is null")
			get_tree().change_scene("res://Scenes/Levels/Level_" + str(current_level + 1) + ".tscn")
	else:
		$Interactables/Portals/Portal/Label.visible = true

func _on_Player_death():
	$UI/TimerDisplay.restart_timer()
	$Interactables/Portals/Portal/Label.visible = false
	$Player.is_unlocked = false
	$Player.can_run = false
	$Player.move_dir = 1
	$Player.global_position = $PlayerSpawn.position
	respawn_interactables()    

func _on_Player_restart(): 
	$UI/TimerDisplay.restart_timer()
	$Interactables/Portals/Portal/Label.visible = false
	$Player.is_unlocked = false
	$Player.velocity.x = 0
	$Player.global_position = $PlayerSpawn.position
	respawn_interactables()    

func respawn_interactables():
	for key in get_tree().get_nodes_in_group("keys"):
		if !key.visible:
			key.visible = true
			key.get_node("Area2D").set_collision_mask_bit(0, true)
	
	for collectable in get_tree().get_nodes_in_group("collectables"):
		if !collectable.visible:
			collectable.visible = true
			collectable.get_node("Area2D").set_collision_mask_bit(0, true)
