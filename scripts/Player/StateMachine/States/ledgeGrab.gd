extends State
class_name LedgeGrab

func enter() -> void:
	super.enter()
	
	playback.travel("LedgeGrab")
	core.velocitySandbox = Vector3.ZERO
	core.canChangeDir = false
	
	core.position = core.onLedgePosition
	
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = -.25 * core.flatDir.x
	core.VisualsNode.position.z = -.25 * core.flatDir.z
	core.VisualsNode.position.y = -.4
	pass

func exit() -> void:
	super.exit()
	core.canChangeDir = true
	
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = 0
	core.VisualsNode.position.y = 0
	core.VisualsNode.position.z = 0
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	core.velocitySandbox = Vector3.ZERO
	
	if inputHandler.blockInput:
		if core.CanParry():
			machine.rpc("change_state", "Parry")
		else:
			machine.rpc("change_state", "Block")
		return
	
	#TODO: fix later
	if inputHandler.lookDirection < 0:
		core.position.y -= 0.15
		machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	elif Input.is_action_just_pressed("moveUp") and core.IsSpaceToClimb():
		machine.rpc("change_state", "LedgeClimb")
	elif core.jumpInputBufferTimer > 0:
		machine.rpc("change_state", "Jump")
	pass
