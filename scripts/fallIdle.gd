extends AirState
class_name FallIdle

func enter() -> void:
	super.enter()
	
	#core.velocity.x = 0

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if core.MovementDirection() != 0:
		machine.change_state("FallMove")
