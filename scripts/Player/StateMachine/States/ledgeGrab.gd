extends State
class_name LedgeGrab

func enter() -> void:
	super.enter()
	
	playback.travel("LedgeGrab")
	core.velocitySandbox = Vector3.ZERO
	
	core.position = core.onLedgePosition
	
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = -.25 * core.facingDirection
	core.VisualsNode.position.y = -.4
	pass

func exit() -> void:
	super.exit()
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = 0
	core.VisualsNode.position.y = 0
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if inputHandler.blockInput:
		if core.CanParry():
			#machine.change_state("Parry")
			machine.rpc("change_state", "Parry")
		else:
			#machine.change_state("Block")
			machine.rpc("change_state", "Block")
		return
	
	if inputHandler.lookDirection < 0:
		machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	elif not core.IsLedgeDetected():
		machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	elif inputHandler.lookDirection > 0 and core.IsSpaceToClimb():
		machine.change_state("LedgeClimb")
	elif core.jumpInputBufferTimer > 0:
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
	pass
