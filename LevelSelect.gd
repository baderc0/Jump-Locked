extends Control

var button_scene = preload("res://Scenes/UI/LevelButton.tscn")
var path = "res://Scenes/Levels"
var files = []

func _ready():
	files = populate_array()
	
	for val in files:
		print(val)
	make_buttons()
	
	for button in $MarginContainer/GridContainer.get_children():
		button.connect("level_button_pressed", self, "_on_LevelButton_pressed")
		

func populate_array():
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			file = file.split(".")[0]
			files.append(file)
	dir.list_dir_end()
	return files

func make_buttons():
	for level in files:
		var button = button_scene.instance()
		button.text = str(level)
		get_node("MarginContainer/GridContainer").add_child(button)
		

func _on_Button_button_down():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")

func _on_LevelButton_pressed(var text):
	print("pressed level button: " + text)
	get_tree().change_scene("res://Scenes/Levels/" + text + ".tscn")
