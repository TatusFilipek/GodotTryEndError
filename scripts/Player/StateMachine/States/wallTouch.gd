extends GroundState
class_name WallTouch

func enter() -> void:
	super.enter()
	
	core.velocitySandbox.x = 0
	playback.travel("WallTouch")
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = -.4 * core.facingDirection
	pass

func exit() -> void:
	super.exit()
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = 0
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if not core.isOnWall():
		machine.ChangeStateMoveOrIdle("Idle", "Walk")
	elif inputHandler.interact:
		machine.change_state("WallGrab")
	elif inputHandler.crouchInput:
		machine.ChangeStateMoveOrIdle("CrouchIdle", "CrouchWalk")
	#NOTE: add a raycast that checks for a body that can be moved, and if it is found change state to WallGrab
	pass
