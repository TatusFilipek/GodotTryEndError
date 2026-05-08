extends Crouch
class_name CrouchWalk

func enter() -> void:
	super.enter()
	
	playback.travel("CrouchWalk")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	if not core.dashing:
		core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.crouchMovementMult * core.ALLMOVEMENTVARIABLE * _delta
	
	if core.MovementDirection() == 0:
		machine.change_state("CrouchIdle")
		return
	
	if not Input.is_action_pressed("crouch"):
		changeState("Walk")
		return
	
	if Input.is_action_pressed("sprint"):
		machine.change_state("Slide")
		return
