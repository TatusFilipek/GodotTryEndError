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
	
	if not core.isCollidingShapecast(core.CheckSpaceCrouch) and not inputHandler.crouchInput:
			core.resizeCollider(0)
			core.isCrouching = false
	
	#before all those state changing ifs add ifs checking for action inputs and change state to said action
	if inputHandler.blockInput:
		if core.CanParry():
			machine.change_state("Parry")
		else:
			machine.change_state("Block")
		return
	
	#hotbar abilities
	for action in core.Hotbar:
		if Input.is_action_just_pressed(action): 
			machine.change_state(core.Hotbar[action].name)
	
	if not core.isOnGround():
		machine.ChangeStateMoveOrIdle("FallIdle", "FallMove")
	elif core.CanJump() and not core.isCollidingShapecast(core.CheckSpaceCrouch):
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
	elif inputHandler.dashInput and core.CanDash():
		machine.change_state("Dash")
	elif core.is_on_wall():
		#check for wall on bottom
		if core.isCollidingRaycast(core.CheckWallTop) and not core.isCrouching and machine.current_state.name != "WallTouch" and machine.current_state.name != "WallGrab":
			machine.change_state("WallTouch")
	pass
