extends GroundState
class_name Crouch

func enter() -> void:
	super.enter()
	#resize collider
	core.Collider.shape.set("height", 66)
	core.Collider.position.y = 15
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: 
		#resize collider
		core.Collider.shape.set("height", 96)
		core.Collider.position.y = 0
		return
	pass

func changeState(_name) -> void:
	#resize collider
	core.Collider.shape.set("height", 96)
	core.Collider.position.y = 0
	machine.change_state(_name)
