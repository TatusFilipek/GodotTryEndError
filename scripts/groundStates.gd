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
	
	core.AllCheckUpdate()
	
	if not core.isOnGround():
		machine.change_state("FallIdle")
		return
		
	if core.jumpInputBufferTimer > 0 and core.coyoteTimer > 0:
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
		return
	
	if Input.is_action_just_pressed("dash") and not core.dashing and not core.rolling and core.dashUses > 0:
		machine.change_state("Dash")
		return
	
	if core.is_on_wall():
		machine.change_state("WallTouch")
		return
	pass
