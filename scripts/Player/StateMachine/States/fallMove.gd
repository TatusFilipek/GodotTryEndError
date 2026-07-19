extends AirState
class_name FallMove

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	var maxMovementSpeed =  core.MovementSpeed * core.sprintMovementMult
	
	if not core.dashing and inputHandler.movementDirection != 0:
		if abs(core.velocitySandbox.x) <= maxMovementSpeed:
			core.velocitySandbox.x += (maxMovementSpeed * inputHandler.movementDirection * core.airDrag * 1) * _delta
			core.velocitySandbox.x = clamp(core.velocitySandbox.x, -maxMovementSpeed, maxMovementSpeed)
		else:
			core.velocitySandbox.x -= core.velocitySandbox.x * core.airDrag * .5 * _delta
	if not isActive: return
	
	if inputHandler.movementDirection == 0:
		machine.change_state("FallIdle")
