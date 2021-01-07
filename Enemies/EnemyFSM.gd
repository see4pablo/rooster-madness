extends "res://StateMachine.gd"

func _ready():

	add_state("idle")
	add_state("walk_left")
	add_state("walk_right")
	add_state("follow_left")
	add_state("follow_right")
	add_state("damaged")
	add_state("dead")
	call_deferred("set_state", states.idle)
	
func _state_logic(delta):

	parent._apply_gravity(delta)
	parent._apply_movement(delta)

func _get_transition(delta):
	match state:
		states.idle:
			if parent.checker_left.is_colliding():
				return states.follow_left
			elif parent.checker_right.is_colliding():
				return states.follow_right
			else:
				return states.walk_right
		states.walk_left:
			if parent.checker_left.is_colliding():
				return states.follow_left
			elif parent.checker_right.is_colliding():
				return states.follow_right
			elif parent.velocity.x == 0:
				return states.walk_right
		states.walk_right:
			if parent.checker_left.is_colliding():
				return states.follow_left
			elif parent.checker_right.is_colliding():
				return states.follow_right
			elif parent.velocity.x == 0:
				return states.walk_left
		states.follow_left:
			if not parent.checker_left.is_colliding():
				return states.walk_left
		states.follow_right:
			if not parent.checker_right.is_colliding():
				return states.walk_right

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.state_info.text = "idle"
			parent.anim_sprite.play("idle")
		states.walk_left:
			parent.state_info.text = "walk_left"
			parent.velocity.x = Globals.LEFT * parent.move_speed
		states.follow_left:
			parent.state_info.text = "follow_left"
			parent.velocity.x = Globals.LEFT * parent.move_speed
		states.walk_right:
			parent.state_info.text = "walk_right"
			parent.velocity.x = Globals.RIGHT * parent.move_speed
		states.follow_right:
			parent.state_info.text = "follow_right"
			parent.velocity.x = Globals.RIGHT * parent.move_speed
		states.damaged:
			parent.state_info.text = "damaged"
			parent.anim_sprite.play("getHit")
		states.dead:
			parent.state_info.text = "dead"
			parent.anim_sprite.play("die")
			parent._on_dead()

func _exit_state(old_state, new_state):
	pass
		

func _receive_hit():

	if(parent._is_dead()):
		set_state(states.dead)
		parent.dead_timer.start()
		return true
	else:
		set_state(states.damaged)
		return false

func _on_hit_checker_body_entered(body):

	if state != states.damaged and \
		body.is_class("KinematicBody2D") and body.has_method("get_attacked"):
		print(body.playerFSM.states.keys()[body.playerFSM.state])
		body.get_attacked(parent)

func _on_Receive_hit_timeout():
	set_state(states.idle)


 
