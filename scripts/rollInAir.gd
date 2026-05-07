extends Roll
class_name RollInAir


func enter() -> void:
	super.enter()
	
	playback.travel("RollInAir")
	animation.set_frame_and_progress(core.rollAnimFrame, core.rollAnimProgress)
	
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	core.velocity.y += core.CalcGravity() * _delta; # Gravity
	
	#TODO: fix later	
	if core.isOnGround():
		core.rollAnimFrame = animation.frame
		core.rollAnimProgress = animation.frame_progress
				
		machine.change_state("RollGround")
		return

func AnimationFinished() -> void:
	core.rollAnimFrame = 0
	core.rollAnimProgress = 0
	machine.change_state("FallIdle")
