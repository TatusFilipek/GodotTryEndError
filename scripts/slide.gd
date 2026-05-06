extends GroundState
class_name Slide

var velocityXSandBox : float

func enter() -> void:
	super.enter()
	
	playback.travel("Slide")
	
	core.velocity.x = core.facingDirection * core.slideForce
	
	pass

func exit() -> void:
	super.exit()
	core.velocity.x = 0
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	#NOTE: this will need some fixxing
	
	if (1 - core.spriteRotation) >= 1:
		core.velocity.x = core.facingDirection * (abs(core.velocity.x) - core.slideVelocityLoss * (1 - core.spriteRotation) * _delta)
	else:
		core.velocity.x += core.facingDirection * (core.slideForce * (1 - -1 * core.spriteRotation) - abs(core.velocity.x)) * _delta
	
	if sign(core.velocity.x) != sign(core.facingDirection):
		core.velocity.x *= -1
	
	if core.slideCancelVelocity > abs(core.velocity.x) and core.spriteRotation <= 0:
		machine.change_state("Idle")
		return
	
	if not Input.is_action_pressed("crouch"):
		machine.change_state("Idle")
		return
	
	#add leaping
	#if core.jumpInputBufferTimer > 0 and core.coyoteTimer > 0:
		#core.coyoteTimer = 0
		#core.jumpInputBufferTimer = 0
		#machine.change_state("Jump")
		#return

	pass
