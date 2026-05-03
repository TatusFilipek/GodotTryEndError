extends GroundState
class_name Idle

func enter() -> void:
	super.enter()
	
	playback.travel("Idle")
	#core.velocity.x = 0

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if core.MovementDirection() != 0:
		machine.change_state("Walk")
		return
		
	if Input.is_action_pressed("crouch"):
		machine.change_state("CrouchIdle")
		return
