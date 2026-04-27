extends GroundState
class_name Idle

func enter() -> void:
	super.enter()
	
	animation.play("Idle")
	#core.velocity.x = 0

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
		
	if core.MovementDirection() != 0:
		machine.change_state("Move")
