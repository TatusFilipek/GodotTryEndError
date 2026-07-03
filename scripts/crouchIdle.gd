extends Crouch
class_name CrouchIdle

func enter() -> void:
	super.enter()
	
	playback.travel("CrouchIdle")

func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if core.MovementDirection() != 0:
		machine.change_state("CrouchWalk")
	elif not Input.is_action_pressed("crouch"):
		core.velocity.x = 0
		changeState("Idle")
	else:
		core.velocity.x = 0
