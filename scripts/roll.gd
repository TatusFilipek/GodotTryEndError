extends State
class_name Roll


func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	core.rolling = true
	pass

func exit() -> void:
	super.exit()
	
	core.canChangeDir = true
	core.rolling = false
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if abs(core.velocity.x) > core.rollVelocityTreshold: 
		core.velocity.x -= core.rollVelocityLoss * core.facingDirection * _delta
	else:
		core.velocity.x = 0
	pass
