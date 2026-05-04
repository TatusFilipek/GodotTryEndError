extends State
class_name LedgeGrab

func enter() -> void:
	super.enter()
	core.position = core.GetLedgePosition()
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if Input.is_action_pressed("moveDown"):
		machine.change_state("FallIdle")
		return
	pass
