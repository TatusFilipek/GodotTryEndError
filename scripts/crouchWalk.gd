extends GroundState
class_name CrouchWalk

func enter() -> void:
	super.enter()
	
	playback.travel("CrouchWalk")

func exit() -> void:
	super.enter()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.crouchMovementMult * core.ALLMOVEMENTVARIABLE * _delta
	
	if Input.is_action_pressed("sprint"):
		machine.change_state("Run")
		return
	
	if core.MovementDirection() == 0:
		machine.change_state("CrouchIdle")
		return
	
	if not Input.is_action_pressed("crouch"):
		machine.change_state("Walk")
		return
