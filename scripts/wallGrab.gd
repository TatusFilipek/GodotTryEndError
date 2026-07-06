extends GroundState
class_name WallGrab

func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	
	pass

func exit() -> void:
	super.exit()
	
	core.canChangeDir = true
	
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if not Input.is_action_pressed("grab"):
		machine.change_state("WallTouch")
	
	if core.MovementDirection() * core.facingDirection > 0:
		if playback.get_current_node() != "WallPush":
			#playback.travel("WallPush")
			print("fix Later | WallPush")

	elif core.MovementDirection() * core.facingDirection < 0:
		if playback.get_current_node() != "WallPull":
			#playback.travel("WallPull")
			print("fix Later | WallPull")
	else:
		if playback.get_current_node() != "WallTouch":
			#playback.travel("WallTouch")
			print("fix Later | WallTouch")
	
	pass
