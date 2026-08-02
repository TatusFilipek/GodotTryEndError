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
		core.velocitySandbox.x = core.direction.x * core.MovementSpeed * core.crouchMovementMult
		core.velocitySandbox.z = core.direction.z * core.MovementSpeed * core.crouchMovementMult
	
	if not core.direction:
		machine.rpc("change_state", "CrouchIdle")
	elif not inputHandler.crouchInput:
		changeState("Walk")
	elif inputHandler.runInput and not core.isCollidingShapecast(core.check_space_crouch) and not core.isCollidingRaycast(core.check_wall_bottom):
		machine.rpc("change_state", "Slide")
