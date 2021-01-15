extends Node2D

signal can_teleport

func _ready():
	# Connect signal to all portals if there is more than one in a level (basically only tutorial level for now)
	for portal in get_tree().get_nodes_in_group("portals"):
		connect("can_teleport", portal, "_on_Player_can_teleport")
