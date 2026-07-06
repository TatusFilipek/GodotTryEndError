extends GroundState
class_name Idle

func enter() -> void:
	super.enter()
	
	#playback.travel("Idle")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if core.MovementDirection() != 0:
		machine.change_state("Walk")
	elif Input.is_action_pressed("crouch"):
		machine.change_state("CrouchIdle")
	else: core.velocity.x = 0
