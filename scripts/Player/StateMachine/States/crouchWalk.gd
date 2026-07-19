extends Crouch
class_name CrouchWalk

func enter() -> void:
	super.enter()
	
	playback.travel("CrouchWalk")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	if not core.dashing:
		core.velocitySandbox.x = inputHandler.movementDirection * core.MovementSpeed * core.crouchMovementMult
	
	if inputHandler.movementDirection == 0:
		machine.change_state("CrouchIdle")	
	elif not inputHandler.crouchInput:
		changeState("Walk")
	elif inputHandler.runInput and not core.isCollidingShapecast(core.CheckSpaceCrouch) and not core.isCollidingRaycast(core.CheckWallBottom):
		machine.change_state("Slide")
