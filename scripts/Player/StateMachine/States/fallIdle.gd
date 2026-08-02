extends AirState
class_name FallIdle

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if core.direction:
		machine.rpc("change_state", "FallMove")
	
	core.velocitySandbox.x = move_toward(core.velocitySandbox.x, 0, core.airDrag * _delta)
	core.velocitySandbox.z = move_toward(core.velocitySandbox.z, 0, core.airDrag * _delta)
