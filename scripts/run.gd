extends GroundState
class_name Run

func enter() -> void:
	super.enter()
	
	playback.travel("Run")

func exit() -> void:
	super.enter()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.sprintMovementMult * core.ALLMOVEMENTVARIABLE * _delta
	
	if core.MovementDirection() == 0:
		machine.change_state("Idle")
