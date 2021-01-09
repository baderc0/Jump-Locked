extends "res://Scripts/Other/StateMachine.gd"

onready var state_label = get_parent().get_node("StateLabel")
onready var anim = get_parent().get_node("AnimationPlayer")
onready var timer = get_parent().get_node("Timer")

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	add_state("unlock")
	call_deferred("set_state", states.idle)
	parent.connect("trigger_cutscene", self, "play_cutscene")

func _input(event):
	if event.is_action_pressed("jump") && parent.is_grounded():
		parent.jump()
		set_state(states.jump)
	elif state == states.jump && event.is_action_released("jump"):
		parent.velocity.y *= 0.5

# Calls funcs in Player.gd
func _state_logic(delta):
	parent.update_move_dir()
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
			# need to set player input to false here
			anim.play("unlock")
			yield(anim, "animation_finished")
			return states.idle
	return null

# setting anim, tween, timers, etc
func _enter_state(new_state, old_state):
	#state_label.text = states.keys()[state]
	
	# Animations
	match new_state:
		states.idle:
			anim.play("idle")
		states.run:
			anim.play("run")
		states.jump:
			anim.play("jump")
		states.fall:
			anim.play("fall")

func _exit_state(old_state, new_state):
	pass

func play_cutscene():
	print("we have arrived at the scene of cuttage")
	set_state(states.unlock)

func _on_timer_timeout():
	print("finished timer!")
