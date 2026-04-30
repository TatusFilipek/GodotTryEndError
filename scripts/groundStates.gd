extends State
class_name GroundState

func enter() -> void:
	super.enter()
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if not core.is_on_floor():
		machine.change_state("FallIdle")
		return
		
	if core.jumpInputBufferTimer > 0 and core.coyoteTimer > 0:
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
		return

	pass
