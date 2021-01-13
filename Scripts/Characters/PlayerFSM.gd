extends "res://Scripts/Other/StateMachine.gd"

onready var state_label = get_parent().get_node("StateLabel")
onready var anim = get_parent().get_node("AnimationPlayer")
onready var timer = get_parent().get_node("Timer")



func _ready():
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	call_deferred("set_state", states.run)
	parent.connect("trigger_cutscene", self, "play_cutscene")
	print_states()

func print_states():
	print(states.keys())

func _input(event):
	if event.is_action_pressed("shoot"):
		parent.shoot()
	if event.is_action_pressed("jump") && parent.is_grounded && state != states.unlock:
		parent.jump()
		set_state(states.jump)
	elif state == states.jump:
		if event.is_action_released("jump"):
			parent.velocity.y *= 0.4

# Calls funcs in Player.gd
func _state_logic(delta):
	parent.update_move_dir()
	if state != states.unlock:
		parent.handle_move_input()
		parent.apply_gravity(delta)
		parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.is_grounded():
				if abs(parent.velocity.x) > parent.idle_cutoff:
					return states.run 
			else:
				if parent.velocity.y > 0:
					return states.fall
				else:
					return states.jump
		states.run:
			if parent.is_grounded():
				if abs(parent.velocity.x) < parent.idle_cutoff:
					return states.idle
			else:
				if parent.velocity.y > 0:
					return states.fall
				else:
					return states.jump
		states.jump:
			if parent.is_grounded():
				if parent.velocity.x < parent.idle_cutoff:
					return states.idle
				else:
					return states.run
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_grounded():
				if abs(parent.velocity.x) < parent.idle_cutoff:
					return states.idle
				else:
					return states.run
		states.attack:
			pass
		states.unlock:
			pass
	return null

# setting anim, tween, timers, etc
func _enter_state(new_state, old_state):
	state_label.text = states.keys()[state]
	
	# Animations
	if !parent.can_attack:
		match new_state:
			states.idle:
				anim.play("idle_locked")
			states.run:
				anim.play("run_locked")
			states.jump:
				anim.play("jump_locked")
			states.fall:
				anim.play("fall_locked")
	else: # Player picked up key to unlock attack
		match new_state:
			states.idle:
				anim.play("idle_unlocked")
			states.run:
				anim.play("run_unlocked")
			states.jump:
				anim.play("jump_unlocked")
			states.fall:
				anim.play("fall_unlocked")

func _exit_state(old_state, new_state):
	pass

func play_cutscene():
	anim.play("unlock")

func start_unlock():
	set_state(states.unlock)

func end_unlock():
	set_state(states.idle)
