extends State
class_name AirState

func enter() -> void:
	super.enter()
	
	playback.travel("InAir")
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if not core.isCollidingShapecast(core.check_space_crouch):
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
	elif core.CanJump():
		machine.rpc("change_state", "Jump")
		#check for ledge and if ledge detected grab on it
	elif core.IsLedgeDetected() and core.direction and core.velocitySandbox.y < 0:
		machine.rpc("change_state", "LedgeGrab")
	elif inputHandler.dashInput and core.CanDash():
		#machine.rpc("change_state", "Dash")
		machine.rpc("change_state", "Dash")
	else:
		core.velocitySandbox.y -= core.CalcGravity() * _delta; # Gravity
		
		VariableJumpHeight()
	pass

func VariableJumpHeight():
	if core.velocitySandbox.y <= 0:
		core.jumping = false
	
	if core.jumping and inputHandler.jumpInputUp:
		core.velocitySandbox.y *= core.jumpVelocityCut
