extends Node

var player_scene = preload("res://Scenes/Player/Player.tscn")
var player

var UI_scene = preload("res://Scenes/UI/UI.tscn")
var UI

var current_level_path 
var next_level_path 

var level_name
var next_level_name

var level_val

onready var current_level_instance
onready var next_level

func _ready():
	level_val = 2
	current_level_path = "res://Scenes/Levels/Level_" + str(level_val) + ".tscn"
	current_level_instance = load(current_level_path).instance()
	next_level_path = "res://Scenes/Levels/Level_" + str(level_val + 1) + ".tscn"
	load_first_level()
	init_nodes()
	
	current_level_instance.get_node("Interactables/Portals/Portal").connect("portal_touched", self, "_portal_touched")

func load_next_level():
	level_val += 1
	current_level_path = "res://Scenes/Levels/Level_" + str(level_val) + ".tscn"
	next_level_path = "res://Scenes/Levels/Level_" + str(level_val + 1) + ".tscn"
	current_level_instance = load(current_level_path).instance()
	get_tree().current_scene.add_child(current_level_instance)
	init_nodes()
	
func load_first_level():
	get_tree().current_scene.add_child(current_level_instance)

func init_nodes():
	player = player_scene.instance()
	UI = UI_scene.instance()
	
	# Add Player and UI to current Level
	current_level_instance.add_child(player)
	current_level_instance.add_child(UI)
	
	player.global_position = current_level_instance.get_node("PlayerSpawn").position
	
	# UI stuff
	#UI.get_node("LevelLabel/Label").text = str(int(current_level.name))
	#print(current_level.name)

	
	pass

func _on_restart_button_pressed():
	print("restarting")

func _portal_touched():
	print("portal touched")
	load_next_level()
	print_tree_pretty()
	
