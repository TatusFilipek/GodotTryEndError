extends AirState
class_name FallMove

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	var maxMovementSpeed =  core.MovementSpeed * core.sprintMovementMult
	
	if not core.dashing and core.direction:
		if abs(core.velocitySandbox.x) <= maxMovementSpeed:
			core.velocitySandbox.x = move_toward(core.velocitySandbox.x, maxMovementSpeed * core.direction.x, core.airDrag * _delta)
			core.velocitySandbox.z = move_toward(core.velocitySandbox.z, maxMovementSpeed * core.direction.z, core.airDrag * _delta)
		else:
			core.velocitySandbox.x = move_toward(core.velocitySandbox.x, 0, core.airDrag * _delta)
			core.velocitySandbox.z = move_toward(core.velocitySandbox.z, 0, core.airDrag * _delta)
	if not isActive: return
	
	if not core.direction:
		machine.rpc("change_state", "FallIdle")
