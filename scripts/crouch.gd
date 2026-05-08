extends GroundState
class_name Crouch

func enter() -> void:
	super.enter()
	#resize collider
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: 
		#resize collider
		return
	pass

func changeState(_name) -> void:
	#resize collider
	machine.change_state(_name)
