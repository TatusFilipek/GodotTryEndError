extends GroundState
class_name Move

func enter() -> void:
	super.enter()
	
	#animation.play("Walk")
	playback.travel("Move")

func exit() -> void:
	super.enter()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.ALLMOVEMENTVARIABLE * _delta
	
	if core.MovementDirection() == 0:
		machine.change_state("Idle")
