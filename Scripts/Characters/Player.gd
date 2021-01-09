extends KinematicBody2D

const UP = Vector2(0, -1)
const JUMP_VEL = -200

var velocity = Vector2()
var move_speed
var gravity = 500
var move_dir

var is_grounded
# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func apply_movement():
	velocity = move_and_slide(velocity, UP)

func apply_gravity(delta):
	velocity.y += gravity * delta

func handle_move_input():
	velocity.x = lerp(velocity.x, move_speed * get_move_dir(), 0.2)
	pass

func get_move_dir():
	return -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))

func jump():
	velocity.y = JUMP_VEL
