extends Roll
class_name RollGround

func enter() -> void:
	super.enter()
	StartAnim(float(core.rollAnimFrame), "Roll")
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	#TODO: fix later
	if not core.isOnGround():
		core.rollAnimFrame = animationPlayer.current_animation_position
		machine.rpc("change_state", "RollInAir")
		return
