extends GroundState
class_name Run

func enter() -> void:
	super.enter()
	
	playback.travel("Run")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	if not core.dashing:
		core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.sprintMovementMult * core.ALLMOVEMENTVARIABLE * _delta
	
	if core.MovementDirection() == 0:
		machine.change_state("Idle")
	elif Input.is_action_pressed("crouch") and abs(core.velocity.x) > core.slideCancelVelocity:
		machine.change_state("Slide")
		return
