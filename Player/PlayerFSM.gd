extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("dash")
	add_state("glide")
	add_state("damaged")
	add_state("dead")
	call_deferred("set_state", states.idle)
	
func _input(event):
	if event.is_action_pressed("jump"):
		parent.glide_cond = true
		if [states.idle, states.walk].has(state):
			parent.velocity.y += parent.max_jump_velocity
	
	if event.is_action_released("jump"):
		parent.glide_cond = false
	
	if state != states.dash:
		if event.is_action_pressed("dash"):
			set_state(states.dash)
			parent.dash_origin = parent.position
			parent.mouse_target = parent.get_global_mouse_position()
			parent.velocity = (parent.mouse_target - parent.dash_origin).normalized() * parent.dash_speed
		
			
func _state_logic(delta):
	if state != states.dash:
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
			elif parent.glide_cond:
				return states.glide
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.glide_cond:
				return states.glide
			elif parent.velocity.y < 0:
				return states.jump
		states.glide:
			if parent.is_on_floor():
				return states.idle
			elif not parent.glide_cond:
				if parent.velocity.y >= 0:
					return states.jump
				else:
					return states.fall
		states.dash:
			if parent.position.distance_to(parent.dash_origin) >= parent.dash_distance:
				return states.idle	
	return null
		

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.velocity = Vector2.ZERO
			parent.state_info.text = "idle"
			parent.anim_player.play("idle")
		states.walk:
			parent.state_info.text = "walk"
			parent.anim_player.play("walk")
		states.jump:
			parent.state_info.text = "jump"
			parent.anim_player.play("jump")
		states.fall:
			parent.state_info.text = "fall"
			parent.anim_player.play("fall")
		states.dash:
			parent.state_info.text = "dash"
			parent.anim_player.play("dash")
		states.glide:
			parent.state_info.text = "glide"
			parent.anim_player.play("glide")
		states.dash:
			parent.state_info.text = "dash"
			parent.anime_player.play("dash")

func _exit_state(old_state, new_state):
	pass
	
func got_attacked(enemy):
	if state == states.dash:
		enemy.get_hit()
	else:
		parent.receive_hit()
		
