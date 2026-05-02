extends GroundState
class_name CrouchIdle

func enter() -> void:
	super.enter()
	
	playback.travel("CrouchIdle")
	#core.velocity.x = 0

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
		
	if core.MovementDirection() != 0:
		machine.change_state("CrouchWalk")
		return
		
	if not Input.is_action_pressed("crouch"):
		machine.change_state("Idle")
		return
