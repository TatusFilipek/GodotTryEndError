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
			#machine.rpc("change_state", "Parry")
			machine.rpc("change_state", "Parry")
		else:
			#machine.rpc("change_state", "Block")
			machine.rpc("change_state", "Block")
		return
	
	if core.isOnGround():
		machine.ChangeStateMoveOrIdle("Idle", "Walk")
	elif inputHandler.jumpInput and core.coyoteTimer > 0:
		core.coyoteTimer = 0
		machine.rpc("change_state", "Jump")
		#check for ledge and if ledge detected grab on it
	elif core.IsLedgeDetected() and inputHandler.movementDirection != 0 and core.velocitySandbox.y < 0:
		machine.rpc("change_state", "LedgeGrab")
	elif inputHandler.dashInput and core.CanDash():
		#machine.rpc("change_state", "Dash")
		machine.rpc("change_state", "Dash")
	else:
		core.velocitySandbox.y -= core.CalcGravity() * _delta; # Gravity
		
		VariableJumpHeight()
		rpc("SuperDuperAirStateAnims")
	pass

func VariableJumpHeight():
	if core.velocitySandbox.y <= 0:
		core.jumping = false
	
	if core.jumping and inputHandler.jumpInputUp:
		core.velocitySandbox.y *= core.jumpVelocityCut

@rpc("authority", "call_local", "reliable", -1)
func SuperDuperAirStateAnims():
	if playback:
		if core.velocitySandbox.y > core.jumpApex:
			playback.travel("InAirUp")
		elif core.velocitySandbox.y < -core.jumpApex:
			playback.travel("InAirDown")
		else:
			if core.velocitySandbox.y <= 0:
				playback.travel("InAirDownApex")
			else:
				playback.travel("InAirUpApex")
