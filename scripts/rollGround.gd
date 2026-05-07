extends Roll
class_name RollGround


func enter() -> void:
	super.enter()
	
	playback.travel("RollGround")
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	#TODO: fix later	
	if not core.isOnGround():
		machine.change_state("FallIdle")
		return

func AnimationFinished() -> void:
	machine.change_state("Idle")
