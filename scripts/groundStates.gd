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
	
	if not core.isCollidingShapecast(core.CheckSpaceCrouch) and not Input.is_action_pressed("crouch"):
			core.resizeCollider(0)
			core.isCrouching = false
	
	if not core.isOnGround():
		machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
		return
		
	if core.CanJump() and not core.isCollidingShapecast(core.CheckSpaceCrouch):
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
		return
	
	if Input.is_action_just_pressed("dash") and not core.dashing and not core.rolling and core.dashUses > 0:
		machine.change_state("Dash")
		return
	
	if core.is_on_wall():
		#check for wall on bottom
		if core.isCollidingRaycast(core.CheckWallTop) and machine.current_state.name != "WallTouch":
			machine.change_state("WallTouch")
		return
	pass
