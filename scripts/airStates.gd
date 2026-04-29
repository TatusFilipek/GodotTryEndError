extends State
class_name AirState

func enter() -> void:
	super.enter()
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if core.is_on_floor():
		machine.change_state("Idle")
		return
		
	core.velocity.y += CalcGravity() * _delta; # Gravity
	
	VariableJumpHeight()
	SuperDuperAirStateAnims()
	pass

func VariableJumpHeight():
	if core.velocity.y >= 0:
		core.jumping = false
	
	if core.jumping and Input.is_action_just_released("moveUp"):
		core.velocity.y *= core.jumpVelocityCut

func SuperDuperAirStateAnims():
	if playback:
		if core.velocity.y < -core.jumpApex:
			playback.travel("InAirUp")
		elif core.velocity.y > core.jumpApex:
			playback.travel("InAirDown")
		else:
			if core.velocity.y >= 0:
				playback.travel("InAirDownApex")
			else:
				playback.travel("InAirUpApex")

func CalcGravity() -> float:
	var gravityMultiplier = core.normalGravityMult
	if not core.is_on_floor():
		if(core.velocity.y <= -core.gravityBuffer): gravityMultiplier = core.normalGravityMult
		else: if(core.velocity.y > -core.gravityBuffer): gravityMultiplier = core.fallingGravityMult
		
	return gravityMultiplier * core.gravityForce + core.velocity.y * gravityMultiplier/100
