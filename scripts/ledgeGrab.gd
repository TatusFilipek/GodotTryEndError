extends State
class_name LedgeGrab

func enter() -> void:
	super.enter()
	
	playback.travel("LedgeGrab")
	core.velocity = Vector3.ZERO
	
	core.position = core.onLedgePosition
	
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = -.25
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
	
	if Input.is_action_pressed("moveDown"):
		machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	elif not core.IsLedgeDetected():
		machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	elif Input.is_action_pressed("moveUp") and core.IsSpaceToClimb():
		machine.change_state("LedgeClimb")
	elif core.jumpInputBufferTimer > 0:
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
	#if there is space to fit a player and up and a certain direcion is pressed then go to ledge climb, if there isnt space or only up is pressed preform jump
	pass
