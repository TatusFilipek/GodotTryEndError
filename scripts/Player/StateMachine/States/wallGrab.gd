extends GroundState
class_name WallGrab

func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = -.4 * core.facingDirection
	pass

func exit() -> void:
	super.exit()
	
	core.canChangeDir = true
	#NOTE: temporary animation offset
	core.VisualsNode.position.x = 0
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if not inputHandler.interact:
		machine.change_state("WallTouch")
	
	if inputHandler.movementDirection * core.facingDirection > 0:
		if playback.get_current_node() != "WallPush":
			playback.travel("WallPush")
			#print("fix Later | WallPush")

	elif inputHandler.movementDirection * core.facingDirection < 0:
		if playback.get_current_node() != "WallPull":
			playback.travel("WallPull")
			#print("fix Later | WallPull")
	else:
		if playback.get_current_node() != "WallTouch":
			playback.travel("WallTouch")
			#print("fix Later | WallTouch")
	
	pass
