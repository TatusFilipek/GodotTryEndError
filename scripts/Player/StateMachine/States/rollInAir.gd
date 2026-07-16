extends Roll
class_name RollInAir


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
	
	core.velocity.y -= core.CalcGravity() * _delta; # Gravity
	
	if core.isOnGround():
		core.rollAnimFrame = animationPlayer.current_animation_position
		machine.change_state("RollGround")
		return
