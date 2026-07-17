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
		core.velocity.x = inputHandler.movementDirection * core.MovementSpeed
	
	if inputHandler.runInput:
		machine.change_state("Run")
	elif inputHandler.movementDirection == 0:
		machine.change_state("Idle")
	elif inputHandler.crouchInput:
		machine.change_state("CrouchWalk")
