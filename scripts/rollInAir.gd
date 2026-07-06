extends Roll
class_name RollInAir


func enter() -> void:
	super.enter()
	StartAnim(float(core.rollAnimFrame) / 8, "RollInAir")
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	core.velocity.y -= core.CalcGravity() * _delta; # Gravity
	
	if core.isOnGround():
		#core.rollAnimFrame = animation.frame
		machine.change_state("RollGround")
		return

func AnimationFinished() -> void:
	core.rollAnimFrame = 0
	animationPlayer.pause()
	machine.actionExit()
