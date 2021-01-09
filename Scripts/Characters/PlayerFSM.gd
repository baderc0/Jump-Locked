extends "res://Scripts/Other/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	call_deferred("set_state", states.idle)

func _input(event):
	pass

# Calls funcs in Player.gd
func _state_logic(delta):
	parent.apply_gravity()
	parent.handle_move_input()
	parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			pass
		states.run:
			pass
		states.jump:
			pass
		states.fall:
			pass
		states.attack:
			pass
	return null

# setting anim, tween, timers, etc
func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
