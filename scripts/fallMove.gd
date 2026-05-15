extends AirState
class_name FallMove

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	var maxMovementSpeed =  core.MovementSpeed * core.sprintMovementMult
	
	if not core.dashing and core.MovementDirection() != 0:
		if abs(core.velocity.x) < maxMovementSpeed:
			core.velocity.x += (maxMovementSpeed * core.facingDirection * core.airDrag * 2) * _delta
		else:
			core.velocity.x -= core.velocity.x * core.airDrag * .5 * _delta
	if not isActive: return
	
	if core.MovementDirection() == 0:
		machine.change_state("FallIdle")
