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
		
	core.velocity.y += core.CalcGravity() * _delta; # Gravity
	pass
