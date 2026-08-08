extends State
class_name Roll

#NOTE:
	#wiem co sie dzieje animacja ustawia sie na dobra klatke ale w tym samym czasie animacja odpala sie od poczatku co powoduje ze skacze co jakis czas pomiedzy klatkami puki sie nie zakaczy
	#AI mi to rozwiazalo ale szczerze to jest taki slop

func enter() -> void:
	super.enter()
	
	core.resizeCollider(0.7)
	
	core.canChangeDir = false
	
	if core.direction:
		var target_position := core.VisualsNode.global_position - core.direction
		
		var target_transform := core.VisualsNode.global_transform.looking_at(target_position, Vector3.UP)
		
		var target_quat := target_transform.basis.get_rotation_quaternion()
		
		core.VisualsNode.global_transform.basis = Basis(target_quat)
	
	core.rolling = true
	pass

func exit() -> void:
	super.exit()
	
	core.canChangeDir = true
	core.rolling = false
	animationTree.active = true
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if inputHandler.blockInput:
		if core.CanParry():
			machine.rpc("change_state", "Parry")
		else:
			machine.rpc("change_state", "Block")
		
		core.VisualsNode.rotation_degrees.y = 180
		return
	
	var currentVelocity := Vector2(core.velocitySandbox.x, core.velocitySandbox.z).length()
	
	if currentVelocity > core.rollVelocityTreshold:
		var newVelocity := move_toward(currentVelocity, 0, core.rollVelocityLoss * _delta)
		
		if core.direction:
			var target_position := core.VisualsNode.global_position - core.direction
			
			var target_transform := core.VisualsNode.global_transform.looking_at(target_position, Vector3.UP)
			
			var current_quat := core.VisualsNode.global_transform.basis.get_rotation_quaternion()
			var target_quat := target_transform.basis.get_rotation_quaternion()
			var interpolated_quat := current_quat.slerp(target_quat, 9.0 * _delta)
			
			core.VisualsNode.global_transform.basis = Basis(interpolated_quat)
			core.checks.global_transform.basis = core.VisualsNode.global_transform.basis
		
		core.velocitySandbox.x = core.flatDir.x * newVelocity
		core.velocitySandbox.z = core.flatDir.z * newVelocity
	else:
		core.velocitySandbox.x = 0
		core.velocitySandbox.z = 0
	pass

@rpc("authority", "call_local", "reliable", -2)
func StartAnim(_time : float, _animName : String) -> void:
	animationTree.active = false
	
	animationPlayer.play(_animName)
	animationPlayer.seek(_time, true)

func AnimationFinished() -> void:
	core.rollAnimFrame = 0
	animationPlayer.pause()
	machine.actionExit()
