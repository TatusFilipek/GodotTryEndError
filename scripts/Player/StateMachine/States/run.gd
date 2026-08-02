extends GroundState
class_name Run

func enter() -> void:
	super.enter()
	
	playback.travel("Run")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	if not core.dashing:
		core.velocitySandbox.x = core.direction.x * core.MovementSpeed * core.sprintMovementMult
		core.velocitySandbox.z = core.direction.z * core.MovementSpeed * core.sprintMovementMult
	
	if not core.direction:
		machine.rpc("change_state", "Idle")
		#TODO: fix later
	elif inputHandler.crouchInput and abs(core.velocitySandbox.x) > core.slideCancelVelocity:
		machine.rpc("change_state", "Slide")
		return
