extends AirState
class_name Jump

func enter() -> void:
	super.enter()
	
	core.velocitySandbox.y = core.jumpForce
	core.jumping = true
	
	core.coyoteTimer = -1
	core.jumpInputBufferTimer = -1
	
	machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	
func exit() -> void:
	super.exit()

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
