extends Roll
class_name RollInAir


func enter() -> void:
	super.enter()
	
	playback.travel("RollInAir")
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
		machine.change_state("Idle")
		return

func AnimationFinished() -> void:
	machine.change_state("FallIdle")
