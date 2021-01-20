extends Node2D

signal can_teleport

var current_level
signal get_backpack

var death_particle_scene = preload("res://Scenes/Other/PlayerDeathParticle.tscn")
var jump_particle_scene = preload("res://Scenes/Other/JumpingParticles.tscn")

var player_scene = preload("res://Scenes/Player/Player.tscn")
var player

export var next_scene: String

var UI_scene  = preload("res://Scenes/UI/UI.tscn")
var UI

var num_of_collectables = 0

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	for collectable in get_tree().get_nodes_in_group("collectables"):
		num_of_collectables += 1
	
	current_level = int(name)
	player = player_scene.instance()
	player.global_position = $PlayerSpawn.position
	if current_level > 5:
		player.has_backpack = true
	
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
	$Player.connect("player_jump", self, "_on_Player_jump")
	connect("get_backpack", $Player, "_on_Player_get_backpack")
	$UI.connect("pause_screen_selected", self, "_on_PauseScreen_button_selected")
	$UI/LevelEndPopup.connect("restart_button_pressed", self, "_on_restart_button_pressed")
	$UI/LevelEndPopup.connect("next_level_button_pressed", self, "_on_next_level_button_pressed")
	
	# Connect signal to all portals if there is more than one in a level (basically only tutorial level for now)
	#for portal in get_tree().get_nodes_in_group("portals"):
		#connect("can_teleport", s, "_on_Player_can_teleport")

func _input(event):
	if event.is_action_pressed("screenshake_toggle"):
		if $Player/Camera2D/ScreenShake.on:
			$Player/Camera2D/ScreenShake.on = false
		else:
			$Player/Camera2D/ScreenShake.on = true
		print("screenshake toggled!: " + str($Player/Camera2D/ScreenShake.on))
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			$UI/PauseScreen.hide()
		else:
			get_tree().paused = true
			$UI/PauseScreen.show()
	elif event.is_action_pressed("restart"):
		_on_Player_death()
		$Player/Camera2D/ScreenShake.start(0.1, 10, 5, 1)

func _on_get_JumpKey():
	$Player.inc_keys()
	$Player.check_keys()
	$Player.is_unlocked = true

func _process(delta):
	if !$Player.can_run:
		$UI/TimerDisplay.timer_on = false
	else:
		$UI/TimerDisplay.timer_on = true

func _on_get_Collectable():
	$Player/Camera2D/ScreenShake.start(0.2, 5, 5, 5)
	$Player.collectables += 1
	#print(str($Player.collectables))

func change_level():
	if next_scene != "":
		get_tree().change_scene(next_scene)
	else:
		get_tree().change_scene("res://Scenes/Levels/Level_" + str(current_level + 1) + ".tscn")

func _on_Portal_touched():
	if $Player.collectables == num_of_collectables:
		get_tree().paused = true
		$UI/LevelEndPopup.show()
		$UI/LevelEndPopup/Label.text = "You completed Level " + str(current_level) + "!"
	else:
		$Interactables/Portals/Portal/Label.visible = true

func _on_Player_death():
	SoundManager.play_se("player_death")
	var death_particle = death_particle_scene.instance()
	death_particle.position = $Player.global_position
	death_particle.one_shot = true
	death_particle.emitting = true
	add_child(death_particle)
	$Player.global_position = $PlayerSpawn.position
	$Player.num_of_keys = 0
	$Player.clear_keys()
	$Player.is_unlocked = false
	$UI/TimerDisplay.restart_timer()
	$Interactables/Portals/Portal/Label.visible = false
	$Player.collectables = 0
	$Player.can_run = false
	$Player.velocity.x = 0
	$Player.move_dir = 1
	respawn_interactables()  

func _on_Player_jump(var pos, var move_dir):
	var jump_particle = jump_particle_scene.instance()
	jump_particle.position = pos
	jump_particle.one_shot = true
	jump_particle.emitting = true
	
	# Set gravity depending on player move direction
	jump_particle.process_material.gravity.x *= -move_dir
	add_child(jump_particle)
	pass

func _on_restart_button_pressed():
	_on_Player_death()
	$UI/LevelEndPopup.hide()
	get_tree().paused = false

func _on_next_level_button_pressed():
	change_level()
	$UI/LevelEndPopup.hide()
	get_tree().paused = false

func respawn_interactables():
	for key in get_tree().get_nodes_in_group("keys"):
		if !key.visible:
			key.visible = true
			key.alive = true
	
	for collectable in get_tree().get_nodes_in_group("collectables"):
		if !collectable.visible:
			collectable.visible = true
			collectable.get_node("Area2D").set_collision_mask_bit(0, true)

func _on_BackpackArea_body_entered(body):
	get_tree().paused = true
	$AnimationPlayer.play("backpack_cutscene")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer/LockeSprite.queue_free()
	$Backpack.queue_free()
	$Player/Camera2D.current = true
	get_tree().paused = false
	emit_signal("get_backpack")
	$Player.global_position = $BackpackAnimationEnd.position

func _on_OutOfBounds_body_entered(body):
	_on_Player_death()

func _on_PauseScreen_button_selected():
	get_tree().paused = false

