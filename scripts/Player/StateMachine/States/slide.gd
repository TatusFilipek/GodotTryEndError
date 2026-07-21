extends Crouch
class_name Slide

func enter() -> void:
	super.enter()
	
	playback.travel("Slide")
	
	core.velocitySandbox.x = core.facingDirection * core.slideForce
	
	pass

func exit() -> void:
	super.exit()
	#NOTE: REMEMBER ABOUT IT
	#core.velocitySandbox.x = 0
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	#NOTE: this will need some fixxing or mayve it is all right
	
	if (1 - core.spriteRotation) >= 1:
		core.velocitySandbox.x = core.facingDirection * (abs(core.velocitySandbox.x) - core.slideVelocityLoss * (1 - core.spriteRotation) * _delta)
	else:
		core.velocitySandbox.x += core.facingDirection * (core.slideForce * (1 - -1 * core.spriteRotation) - abs(core.velocitySandbox.x)) * _delta
	
	if core.slideCancelVelocity > abs(core.velocitySandbox.x) and core.spriteRotation <= 0:
		ExitSlide()
	elif not inputHandler.crouchInput:
		ExitSlide()
	
	#add leaping
	#if core.jumpInputBufferTimer > 0 and core.coyoteTimer > 0:
		#core.coyoteTimer = 0
		#core.jumpInputBufferTimer = 0
		#machine.rpc("change_state", "Jump")
		#return

	pass

func ExitSlide():
	if core.isCollidingShapecast(core.CheckSpaceCrouch):
		machine.ChangeStateMoveOrIdle("CrouchIdle", "CrouchWalk")
	elif inputHandler.crouchInput:
		machine.ChangeStateMoveOrIdle("CrouchIdle", "CrouchWalk")
	else:
		machine.ChangeStateMoveOrIdle("Idle", "Walk")
