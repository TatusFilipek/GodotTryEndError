extends Action
class_name  Block

func enter():
	super.enter()
	
	core.blocking = true
	pass

func exit():
	super.exit()
	
	core.blocking = false
	pass

func physics_update(_delta: float):
	super.physics_update(_delta)
	
	if not Input.is_action_pressed("block"):
		machine.actionExit()
	
	pass
