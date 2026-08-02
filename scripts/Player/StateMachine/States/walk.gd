extends GroundState
class_name Walk

func enter() -> void:
	super.enter()
	
	playback.travel("Walk")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	if not core.dashing:
		core.velocitySandbox.x = core.direction.x * core.MovementSpeed
		core.velocitySandbox.z = core.direction.z * core.MovementSpeed
	
	if inputHandler.runInput:
		machine.rpc("change_state", "Run")
	elif not core.direction:
		machine.rpc("change_state", "Idle")
	elif inputHandler.crouchInput:
		machine.rpc("change_state", "CrouchWalk")
