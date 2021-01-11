extends KinematicBody2D

signal trigger_cutscene

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

var bullet = preload("res://Scenes/Other/Bullet.tscn")
var anim_tree

const UP = Vector2(0, -1)
const JUMP_VEL = -200
const MAX_SPEED = 80

var bullet_speed = Vector2(100, 0)

var velocity = Vector2()
var move_speed = 100
var gravity = 500
var move_dir = 1
var can_attack
var can_jump 
var is_grounded
var is_unlocked

var idle_cutoff = MAX_SPEED / 6

# Called when the node enters the scene tree for the first time.
func _ready():
	is_unlocked = false
	anim_tree = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	check_state()
	apply_gravity(delta)
	handle_move()
	apply_movement()

func apply_movement():
	play_animation()
	is_grounded = is_grounded()
	$GroundedLabel.text = str(is_grounded)

	# Flip player depending on which way they are moving
	if move_dir == 1:
		sprite.flip_h = false
	elif move_dir == -1:
		sprite.flip_h = true
	velocity = move_and_slide(velocity, UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Flip":
			if collision.collider.is_in_group("flip"):
				print("flip!!!!!")
				flip()

func apply_gravity(delta):
	velocity.y += gravity * delta

func _input(event):
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
	velocity.y = JUMP_VEL
	is_unlocked = false # Lock every time the player jumps

func is_grounded():
	return true if $GroundedRaycast.is_colliding() else false

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

func flip():
	move_dir = -move_dir

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
