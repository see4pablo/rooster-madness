extends "res://StateMachine.gd"

func _ready():

	add_state("idle")
	add_state("walk_left")
	add_state("walk_right")
	add_state("follow_left")
	add_state("follow_right")
	add_state("damaged")
	add_state("dead")
	call_deferred("set_state", states.walk_left)
	
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
		states.walk_left:
			parent.state_info.text = "walk_left"
			if [states.idle, states.walk_right, states.follow_right].has(old_state):
				parent.velocity.x = Globals.LEFT * parent.move_speed
		states.follow_left:
			parent.state_info.text = "follow_left"
			if [states.idle, states.walk_right, states.follow_right].has(old_state):
				parent.velocity.x = Globals.LEFT * parent.move_speed
		states.walk_right:
			parent.state_info.text = "walk_right"
			if [states.idle, states.walk_left, states.follow_left].has(old_state):
				parent.velocity.x = Globals.RIGHT * parent.move_speed
		states.follow_right:
			parent.state_info.text = "follow_right"
			if [states.idle, states.walk_left, states.follow_left].has(old_state):
				parent.velocity.x = Globals.RIGHT * parent.move_speed

func _exit_state(old_state, new_state):
	pass


 
