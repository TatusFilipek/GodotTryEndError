extends GroundState
class_name WallTouch

func enter() -> void:
	super.enter()
	
	core.velocity.x = 0
	playback.travel("WallTouch")
	
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if not core.isCollidingRaycast(core.CheckWall):
		machine.change_state("Idle")
		return
	
	#NOTE: add a raycast that checks for a body that can be moved, and if it is found change state to WallGrab
	if Input.is_action_pressed("grab"):
		machine.change_state("WallGrab")
		return
	
	pass
