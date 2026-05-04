extends AirState
class_name FallMove

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.sprintMovementMult * core.ALLMOVEMENTVARIABLE * _delta
	if not isActive: return
	
	if core.MovementDirection() == 0:
		machine.change_state("FallIdle")
