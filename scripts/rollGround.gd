extends Roll
class_name RollGround

func enter() -> void:
	super.enter()
	StartAnim(float(core.rollAnimFrame) / 8, "RollGround")
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	#TODO: fix later
	if not core.isOnGround():
		core.rollAnimFrame = animation.frame
		machine.change_state("RollInAir")
		return

func AnimationFinished() -> void:
	core.rollAnimFrame = 0
	animationPlayer.pause()
	machine.actionExit()
