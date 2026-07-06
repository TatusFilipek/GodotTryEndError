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
	
	if core.isOnGround():
		machine.ChangeStateMoveOrIdle("Idle", "Walk")
	elif Input.is_action_just_pressed("jump") and core.coyoteTimer > 0:
		core.coyoteTimer = 0
		machine.change_state("Jump")
		#check for ledge and if ledge detected grab on it
	elif core.IsLedgeDetected() and core.MovementDirection() != 0 and core.velocity.y > 0:
		machine.change_state("LedgeGrab")
	elif Input.is_action_just_pressed("dash") and not core.dashing and not core.rolling and core.dashUses > 0:
		machine.change_state("Dash")
	else:
		core.velocity.y += core.CalcGravity() * _delta; # Gravity
		
		VariableJumpHeight()
		SuperDuperAirStateAnims()
	pass

func VariableJumpHeight():
	if core.velocity.y >= 0:
		core.jumping = false
	
	if core.jumping and Input.is_action_just_released("jump"):
		core.velocity.y *= core.jumpVelocityCut

func SuperDuperAirStateAnims():
	if playback:
		if core.velocity.y < -core.jumpApex:
			print("fix Later")
			#playback.travel("InAirUp")
		elif core.velocity.y > core.jumpApex:
			print("fix Later")
			#playback.travel("InAirDown")
		else:
			if core.velocity.y >= 0:
				print("fix Later")
				#playback.travel("InAirDownApex")
			else:
				print("fix Later")
				#playback.travel("InAirUpApex")
