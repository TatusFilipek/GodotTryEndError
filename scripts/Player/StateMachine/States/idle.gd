extends GroundState
class_name Idle

func enter() -> void:
	super.enter()
	
	playback.travel("Idle")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if inputHandler.movementDirection != 0:
		machine.change_state("Walk")
	elif inputHandler.crouchInput:
		machine.change_state("CrouchIdle")
	else: core.velocitySandbox.x = 0
