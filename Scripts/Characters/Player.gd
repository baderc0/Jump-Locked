extends KinematicBody2D

onready var sprite = $Sprite


const UP = Vector2(0, -1)
const JUMP_VEL = -200
const MAX_SPEED = 150

var velocity = Vector2()
var move_speed = 100
var gravity = 500
var move_dir

var idle_cutoff = MAX_SPEED / 6

var is_grounded
# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func apply_movement():
	print(velocity)
	print("testing")
	is_grounded = is_grounded()
	$GroundedLabel.text = str(is_grounded)
	
	# Flip player depending on which way they are moving
	if move_dir == 1:
		sprite.flip_h = false
	elif move_dir == -1:
		sprite.flip_h = true
	velocity = move_and_slide(velocity, UP)

func apply_gravity(delta):
	velocity.y += gravity * delta

func handle_move_input():
	velocity.x = lerp(velocity.x, MAX_SPEED * move_dir, get_h_weight())

# Player has less control in the air
func get_h_weight():
	return 0.2 if is_grounded() else 0.2

func update_move_dir():
	move_dir =  -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))

func jump():
	velocity.y = JUMP_VEL

func is_grounded():
	return true if $GroundedRaycast.is_colliding() else false
