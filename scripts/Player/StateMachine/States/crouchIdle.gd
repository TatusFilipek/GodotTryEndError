extends Crouch
class_name CrouchIdle

func enter() -> void:
	super.enter()
	
	playback.travel("CrouchIdle")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if inputHandler.movementDirection != 0:
		machine.rpc("change_state", "CrouchWalk")
	elif not inputHandler.crouchInput:
		core.velocitySandbox.x = 0
		changeState("Idle")
	else:
		core.velocitySandbox.x = 0
