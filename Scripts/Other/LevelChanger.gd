extends Node


var player_scene = preload("res://Scenes/Characters/Player.tscn")
var player

var current_level_path setget current_level_path_set
var next_level_path setget next_level_path_set 

var level_name
var next_level_name

var level_val
var level_end_popup

onready var current_level # Actual scene
onready var next_level

func _ready():
	level_val = 2
	current_level_path_set("res://Scenes/Levels/Level_" + str(level_val) + ".tscn")
	next_level_path_set("res://Scenes/Levels/Level_" + str(level_val + 1) + ".tscn")
	
	load_first_level()

func show_level_end():
	level_end_popup = get_tree().current_scene.get_node("UI/LevelEndPopup")
	level_end_popup.connect("restart_button_pressed", self, "_on_restart_button_pressed")
	level_end_popup.popup()

func load_level():
	get_tree().change_scene(next_level_path)
	level_val += 1
	current_level_path_set("res://Scenes/Levels/Level_" + str(level_val) + ".tscn")
	next_level_path_set("res://Scenes/Levels/Level_" + str(level_val + 1) + ".tscn")

func load_first_level():
	get_tree().change_scene(current_level_path)

func current_level_path_set(var path):
	current_level_path = path

func next_level_path_set(var path):
	next_level_path = path

func _on_restart_button_pressed():
	print("restarting")


