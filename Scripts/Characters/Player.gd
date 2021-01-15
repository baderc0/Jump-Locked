extends KinematicBody2D

signal trigger_cutscene
signal player_death
signal player_get_collectable

onready var sprite = $Sprite
onready var anim = $AnimationPlayer


var collectables = 0

var bullet = preload("res://Scenes/Other/Bullet.tscn")
var anim_tree

const UP = Vector2(0, -1)
const JUMP_VEL = -200
const MAX_SPEED = 150

var bullet_speed = Vector2(100, 0)

var velocity = Vector2()
var move_speed = 500
var gravity = 500
var move_dir = 1
var can_attack
var can_jump 
var is_grounded
var is_unlocked
var can_run

var is_zoomed_in = false

var idle_cutoff = MAX_SPEED / 6

var spawn_pos
var last_checkpoint

var checkpoint_unlocked_state

# Called when the node enters the scene tree for the first time.
func _ready():
	can_run = false
	is_unlocked = false
	anim_tree = $AnimationTree.get("parameters/playback")
	
	# Connecting signals
	connect("player_death", get_parent(), "_on_Player_death")
	connect("player_get_collectable", get_parent(), "_on_Player_get_Collectable")

func _physics_process(delta):
	check_state()
	print("CAN RUN IN PP: " + str(can_run))
	if can_run:
		handle_move()
	else:
		wait_for_keypress()
	apply_movement()
	apply_gravity(delta)

func wait_for_keypress():
	if Input.is_action_pressed("move_left"):
		move_dir = -1
		can_run = true
	elif Input.is_action_pressed("move_right"):
		move_dir = 1
		can_run = true
	elif Input.is_action_just_pressed("map"):
		show_map()

func show_map():
	if !is_zoomed_in:
		$Camera2D.zoom = Vector2(1.5, 1.5)
		is_zoomed_in = true
	else:
		$Camera2D.zoom = Vector2(0.3, 0.3)
		is_zoomed_in = false

func apply_movement():
	play_animation()
	is_grounded = is_grounded()
	$GroundedLabel.text = str(is_grounded)

	if $Rig/ForwardRaycast.is_colliding():
		flip()
	check_facing_direction()
	velocity = move_and_slide(velocity, UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Water":
			print("player died! lol")
			die()

func apply_gravity(delta):
	velocity.y += gravity * delta

func _input(event):
	if event.is_action_pressed("restart"):
		if last_checkpoint != null:
			self.global_position = last_checkpoint
		else:
			restart_stage()
	
	if event.is_action_pressed("jump") && can_jump:
		if is_unlocked:
			print("jump unlock")
			anim_tree.travel("jump_unlocked")
			jump()
		else:
			anim_tree.travel("jump_locked")
			jump()
	elif event.is_action_released("jump"):
		velocity.y *= 0.4

func handle_move():
	velocity.x = lerp(velocity.x, MAX_SPEED * move_dir, get_h_weight())

# Player has less control in the air
func get_h_weight():
	return 0.2 if is_grounded() else 0.075

func update_move_dir():
	move_dir =  -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))

func jump():
	SoundManager.play_se("player_jump")
	SoundManager.set_volume_db(-30, "player_jump")
	velocity.y = JUMP_VEL
	is_unlocked = false # Lock every time the player jumps

func is_grounded():
	return true if $Rig/GroundedRaycast.is_colliding() else false

func check_state():
	$UnlockedLabel.text = str(is_unlocked)
	if is_unlocked:
		anim_tree.travel("run_unlocked")
		can_jump = true
		can_attack = true
	else:
		anim_tree.travel("run_locked")
		can_jump = false
		can_attack = false

func get_key():
	print("key in player")
	is_unlocked = true

# Changes move_dir and flips character Rig and CollisionShape
func flip():
	SoundManager.play_se("player_hit_wall")
	SoundManager.set_volume_db(-30, "player_hit_wall")
	move_dir = -move_dir
	
func check_facing_direction():
	if move_dir == 1:
		$Rig.scale.x = 1
	elif move_dir == -1:
		$Rig.scale.x = -1

func play_animation():
	if is_unlocked:
		anim_tree.travel("run_unlocked")
	else:
		anim_tree.travel("run_locked")
	pass

func shoot():
	print(move_dir)
	print("shoot")
	var bullet_instance = bullet.instance()
	bullet_instance.position = $Muzzle.get_global_position()
	get_tree().get_root().add_child(bullet_instance)
	
	if move_dir == 1:
		bullet_instance.change_dir(1)
	elif move_dir == -1:
		bullet_instance.change_dir(-1)

func checkpoint(var global_pos):
	print("you have reached a checkpoint")
	last_checkpoint = Vector2(global_pos[2][0], global_pos[2][1])
	checkpoint_unlocked_state = is_unlocked
	
func die():
	emit_signal("player_death")
	
	if last_checkpoint != null:
		is_unlocked = checkpoint_unlocked_state
		self.global_position = last_checkpoint
	else:
		is_unlocked = false
		self.move_dir = 1
		self.global_position = spawn_pos

func restart_stage():
	emit_signal("player_death")
	global_position = spawn_pos                
	is_unlocked = false
	can_run = false
	velocity.x = 0
	pass

func get_num_of_Collectables():
	return collectables

func get_collectable():
	print("player get collectable")
	collectables += 1
	emit_signal("player_get_collectable")

func play_walk_sound():
	pass
	#SoundManager.play_se("player_walk_2")
	#SoundManager.set_volume_db(-30, "player_walk_2")




