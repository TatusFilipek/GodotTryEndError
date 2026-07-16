extends GroundState
class_name Crouch

func enter() -> void:
	super.enter()
	#resize collider
	core.resizeCollider(0.7)
	core.isCrouching = true
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: 
		#resize collider
		if not core.isCollidingShapecast(core.CheckSpaceCrouch) and not Input.is_action_pressed("crouch"):
			core.resizeCollider(0)
			core.isCrouching = false
		return
	pass

func changeState(_name) -> void:
	#resize collider
	if core.isCollidingShapecast(core.CheckSpaceCrouch): return
	core.resizeCollider(0)
	core.isCrouching = false
	machine.change_state(_name)
