extends AirState
class_name FallIdle

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if core.MovementDirection() != 0:
		machine.change_state("FallMove")
	
	core.velocity.x = 0
