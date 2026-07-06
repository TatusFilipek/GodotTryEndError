extends AirState
class_name Jump

func enter() -> void:
	super.enter()
	
	core.velocity.y = core.jumpForce
	core.jumping = true
	
	machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	
func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
