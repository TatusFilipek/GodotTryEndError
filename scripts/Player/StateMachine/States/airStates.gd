extends State
class_name AirState

func enter() -> void:
	super.enter()
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if not core.isCollidingShapecast(core.CheckSpaceCrouch):
			core.resizeCollider(0)
			core.isCrouching = false
	
	#before all those state changing ifs add ifs checking for action inputs and change state to said action
	if inputHandler.blockInput:
		if core.CanParry():
			machine.change_state("Parry")
		else:
			machine.change_state("Block")
		return
	
	if core.isOnGround():
		machine.ChangeStateMoveOrIdle("Idle", "Walk")
	elif inputHandler.jumpInput and core.coyoteTimer > 0:
		core.coyoteTimer = 0
		machine.change_state("Jump")
		#check for ledge and if ledge detected grab on it
	elif core.IsLedgeDetected() and inputHandler.movementDirection != 0 and core.velocity.y < 0:
		machine.change_state("LedgeGrab")
	elif inputHandler.dashInput and core.CanDash():
		machine.change_state("Dash")
	else:
		core.velocity.y -= core.CalcGravity() * _delta; # Gravity
		
		VariableJumpHeight()
		SuperDuperAirStateAnims()
	pass

func VariableJumpHeight():
	if core.velocity.y <= 0:
		core.jumping = false
	
	if core.jumping and inputHandler.jumpInputUp:
		core.velocity.y *= core.jumpVelocityCut

func SuperDuperAirStateAnims():
	if playback:
		if core.velocity.y > core.jumpApex:
			playback.travel("InAirUp")
		elif core.velocity.y < -core.jumpApex:
			playback.travel("InAirDown")
		else:
			if core.velocity.y <= 0:
				playback.travel("InAirDownApex")
			else:
				playback.travel("InAirUpApex")
