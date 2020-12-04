extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("dash")
	call_deferred("set_state", states.idle)
	
func _input(event):
	if [states.idle, states.walk]:
		#JUMP
		if event.is_action_pressed("jump") && parent.is_on_floor():
			parent.velocity.y += parent.max_jump_velocity
	if state == states.jump:	
		if event.is_action_released("jump") && parent.velocity.y < parent.min_jump_velocity:
			parent.velocity.y = -parent.min_jump_velocity
	
func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement(delta)
	
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.walk
		states.walk:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
	return null
		

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.walk:
			parent.anim_player.play("walk")
		states.fall:
			parent.anim_player.play("fall")

func _exit_state(old_state, new_state):
	pass
