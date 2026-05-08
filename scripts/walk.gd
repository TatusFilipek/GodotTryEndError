extends GroundState
class_name Walk

func enter() -> void:
	super.enter()
	
	playback.travel("Walk")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	if not core.dashing:
		core.velocity.x = core.MovementDirection() * core.MovementSpeed * core.ALLMOVEMENTVARIABLE * _delta
	
	if Input.is_action_pressed("sprint"):
		machine.change_state("Run")
		return
	
	if core.MovementDirection() == 0:
		machine.change_state("Idle")
		return
	
	if Input.is_action_pressed("crouch"):
		machine.change_state("CrouchWalk")
		return
