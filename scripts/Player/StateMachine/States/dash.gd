extends State
class_name Dash

var dashDirection : Vector2
var dashTimer = 0

func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	core.dashing = true
	
	#resizing colliders
	if inputHandler.crouchInput:
		core.resizeCollider(0.7)
	
	core.dashCooldownTimer = core.dashCooldown
	core.dashUses -= 1
	dashTimer = core.dashDuration
	
	#fix direction calculation
	dashDirection.x = inputHandler.movementDirection
	if inputHandler.movementDirection == 0 and inputHandler.lookDirection == 0:
		dashDirection.x = core.facingDirection
	dashDirection.y = inputHandler.lookDirection
	
	#turn off player sticking to ground and such
	
	dashDirection = dashDirection.normalized()
	
	core.velocity = Vector3(dashDirection.x, dashDirection.y, 0) * core.dashVelocity
	
	pass

func exit() -> void:
	super.exit()
	core.dashing = false
	core.canChangeDir = true
	
	if not core.isOnGround():
		core.dashUses = 0
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if dashTimer <= 0:
		core.dashUses = 0
		machine.actionExit()
		return
	
	dashTimer -= _delta
	
	if inputHandler.blockInput:
		core.dashUses = 0
		if core.CanParry():
			machine.change_state("Parry")
		else:
			machine.change_state("Block")
		return
	
	if inputHandler.feintInput:
		if core.isOnGround():
			machine.change_state("RollGround")
			return
		else:
			core.dashUses = 0
			machine.change_state("RollInAir")
			return
	
	if not core.isOnGround() and dashDirection.y == 0:
		core.velocity.y -= core.CalcGravity() / 1.5 * _delta
	pass
