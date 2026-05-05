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
	
	if not core.is_on_floor() and not core.CheckFloorFront.is_colliding() and not core.CheckFloorBack.is_colliding():
		machine.change_state("FallIdle")
		return
		
	if core.jumpInputBufferTimer > 0 and core.coyoteTimer > 0:
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
		return
	
	if core.is_on_wall():
		machine.change_state("WallTouch")
		return
	
	core.velocity.y += core.CalcGravity() * _delta; # Gravity
	pass
