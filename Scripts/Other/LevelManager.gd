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
onready var next_level_instance
onready var next_level

func _ready():
	level_val = 1
	current_level_path = "res://Scenes/Levels/Level_" + str(level_val) + ".tscn"
	current_level_instance = load(current_level_path)
	next_level_path = "res://Scenes/Levels/Level_" + str(level_val + 1) + ".tscn"
	load_first_level()
	init_nodes()
	
	get_node("Level_" + str(level_val) + "/Interactables/Portals/Portal").connect("portal_touched", self, "_portal_touched")

func load_next_level():
	add_child(next_level_instance.instance())
	level_val += 1
	current_level_path = "res://Scenes/Levels/Level_" + str(level_val) + ".tscn"
	next_level_path = "res://Scenes/Levels/Level_" + str(level_val + 1) + ".tscn"
	get_node("Level_" + str(level_val - 1)).queue_free()
	print_tree_pretty()
	init_nodes()
	
func load_first_level():
	next_level_instance = load(next_level_path)
	add_child(current_level_instance.instance())
	
	#get_tree().current_scene.add_child(current_level_instance)

func init_nodes():
	player = player_scene.instance()
	UI = UI_scene.instance()
	
	get_node("Level_" + str(level_val)).add_child(player)
	player.global_position = get_node("Level_" + str(level_val) + "/PlayerSpawn").position
	get_node("Level_" + str(level_val)).add_child(UI)
	pass

func _on_restart_button_pressed():
	print("restarting")

func _portal_touched():
	print("portal touched")
	load_next_level()
	
