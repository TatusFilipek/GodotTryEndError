extends Crouch
class_name Slide

func enter() -> void:
	super.enter()
	
	playback.travel("Slide")
	
	core.canChangeDir = false
	
	if core.direction:
		var target_position := core.VisualsNode.global_position - core.direction
		
		var target_transform := core.VisualsNode.global_transform.looking_at(target_position, Vector3.UP)
		
		var target_quat := target_transform.basis.get_rotation_quaternion()
		
		core.VisualsNode.global_transform.basis = Basis(target_quat)
	
	var facingDir := core.VisualsNode.global_transform.basis.z.normalized()
	
	core.velocitySandbox.x = facingDir.x * core.slideForce
	core.velocitySandbox.z = facingDir.z * core.slideForce

func exit() -> void:
	super.exit()
	
	core.canChangeDir = true

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	var current_speed := Vector2(core.velocitySandbox.x, core.velocitySandbox.z).length()
	
	var friction_modifier := 1.0 - core.spriteRotation
	
	if friction_modifier >= 1.0:
		current_speed = move_toward(current_speed, 0.0, core.slideVelocityLoss * friction_modifier * _delta)
	else:
		current_speed = move_toward(current_speed, core.slideForce, core.slideForce * abs(friction_modifier) * _delta)
	
	if core.direction:
		var target_position := core.VisualsNode.global_position - core.direction
		
		var target_transform := core.VisualsNode.global_transform.looking_at(target_position, Vector3.UP)
		
		var current_quat := core.VisualsNode.global_transform.basis.get_rotation_quaternion()
		var target_quat := target_transform.basis.get_rotation_quaternion()
		var interpolated_quat := current_quat.slerp(target_quat, 3.0 * _delta)
		
		core.VisualsNode.global_transform.basis = Basis(interpolated_quat)
		core.checks.global_transform.basis = core.VisualsNode.global_transform.basis
	
	var facingDir := core.VisualsNode.global_transform.basis.z.normalized()
	
	core.velocitySandbox.x = facingDir.x * current_speed
	core.velocitySandbox.z = facingDir.z * current_speed

	if current_speed < core.slideCancelVelocity and core.spriteRotation <= 0:
		ExitSlide()
	elif not inputHandler.crouchInput:
		ExitSlide()

func ExitSlide() -> void:
	if core.isCollidingShapecast(core.check_space_crouch):
		machine.ChangeStateMoveOrIdle("CrouchIdle", "CrouchWalk")
	elif inputHandler.crouchInput:
		machine.ChangeStateMoveOrIdle("CrouchIdle", "CrouchWalk")
	else:
		machine.ChangeStateMoveOrIdle("Idle", "Walk")
