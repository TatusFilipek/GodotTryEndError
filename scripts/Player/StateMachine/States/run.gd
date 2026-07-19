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
		core.velocitySandbox.x = inputHandler.movementDirection * core.MovementSpeed * core.sprintMovementMult
	
	if inputHandler.movementDirection == 0:
		machine.change_state("Idle")
	elif inputHandler.crouchInput and abs(core.velocitySandbox.x) > core.slideCancelVelocity:
		machine.change_state("Slide")
		return
