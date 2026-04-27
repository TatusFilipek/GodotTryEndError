extends State
class_name AirState

func enter() -> void:
	super.enter()
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if core.is_on_floor():
		machine.change_state("Idle")
		return
		
	core.velocity.y += core.CalcGravity() * _delta; # Gravity
	
	if core.velocity.y < 0:
		animation.play("Jump")
	else: if core.velocity.y > 0:
		animation.play("Fall")
	pass
