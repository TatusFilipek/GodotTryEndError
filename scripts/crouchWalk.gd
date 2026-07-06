extends Crouch
class_name CrouchWalk

func enter() -> void:
	super.enter()
	
	#playback.travel("CrouchWalk")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	if not core.dashing:
		core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.crouchMovementMult
	
	if core.MovementDirection() == 0:
		machine.change_state("CrouchIdle")	
	elif not Input.is_action_pressed("crouch"):
		changeState("Walk")
	elif Input.is_action_pressed("sprint") and not core.isCollidingShapecast(core.CheckSpaceCrouch):
		machine.change_state("Slide")
