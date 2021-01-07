extends "res://StateMachine.gd"


var jump_pressed = false

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
	
	if event.is_action_pressed("jump") and not jump_pressed:
		
		jump_pressed = true
		parent.glide_cond = true
		
		if [states.idle, states.walk].has(state) and parent.is_on_floor():
			parent.jump_sound.play()		
			parent.velocity.y += parent.max_jump_velocity
	
	if event.is_action_released("jump"):
		jump_pressed = false
		parent.glide_cond = false
	
	if not [states.dash, states.damaged].has(state):
		if event.is_action_pressed("dash") and parent._can_dash():
			set_state(states.dash)
			parent.dash_sound.play()
			parent._dash()
		
			
func _state_logic(delta):
	if not [states.dash, states.damaged].has(state):
		parent._handle_move_input()
	if state != states.dash:
		parent._apply_gravity(delta)
	if state == states.dash:
		if parent.velocity.length() < parent.dash_speed - Globals.EPSILON:
			set_state(states.idle)
	parent._apply_movement(delta)
	
	
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < - Globals.EPSILON:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.walk
		states.walk:
			if !parent.is_on_floor():
				if parent.velocity.y < - Globals.EPSILON:
					return states.jump
				elif parent.velocity.y >= Globals.EPSILON:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.glide_cond:
				return states.glide
			elif parent.velocity.y >= Globals.EPSILON:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.glide_cond:
				return states.glide
			elif parent.velocity.y < - Globals.EPSILON :
				return states.jump
		states.glide:
			if parent.is_on_floor():
				return states.idle
			elif not parent.glide_cond:
				if parent.velocity.y >= Globals.EPSILON:
					return states.fall
				elif parent.velocity.y < - Globals.EPSILON:
					return states.jump
		states.dash:
			if parent.position.distance_to(parent.dash_origin) >= parent.dash_distance:
				return states.idle	
	return null
		

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			if old_state == states.dash:
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
		states.damaged:
			parent.state_info.text = "damaged"
			parent.anim_player.play("damaged")
		states.dead:
			parent.state_info.text = "dead"
			parent.anim_player.play("dead")

func _exit_state(old_state, new_state):
	match old_state:
		states.dash:
			parent.velocity = Vector2.ZERO

	
func get_attacked(enemy):
	if state == states.dash:
		var killed = enemy.get_hit(Globals.PLAYER_DASH_DAMAGE)
		if killed:
			parent._had_killed()
		#vertical jump now
		set_state(states.idle)
		parent.velocity.y += parent.max_jump_velocity
		
		
		
	elif state != states.damaged:
		
		set_state(states.damaged)
		parent._receive_hit()
		
		#bounce to the left
		if(enemy.position.x < parent.position.x):
			parent.velocity = Vector2(-1,1).normalized() * parent.bounce_speed
		#bounce to the right
		else:
			parent.velocity = Vector2(1,1).normalized() * parent.bounce_speed
		
		
		#check death state
		if(parent._is_dead()):
			set_state(states.dead)
		

func _on_DamageCooldown_timeout():
	set_state(states.idle)
	


func _on_DashCooldown_timeout():
	set_state(states.idle)
	parent._dash_available()
