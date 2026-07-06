extends State
class_name Dash

var dashDirection : Vector2

func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	core.dashing = true
	
	#resizing colliders
	if Input.is_action_pressed("crouch"):
		core.resizeCollider(0.5)
	
	core.dashCooldownTimer = core.dashCooldown
	core.dashUses -= 1
	core.dashTimer = core.dashDuration
	
	#fix direction calculation
	dashDirection.x = core.MovementDirection()
	if core.MovementDirection() == 0 and core.LookDirection() == 0:
		dashDirection.x = core.facingDirection
	dashDirection.y = core.LookDirection()
	
	#turn off player sticking to ground and such
	
	dashDirection = dashDirection.normalized()
	
	core.velocity = dashDirection * core.dashVelocity
	
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
	
	if core.dashTimer <= 0:
		machine.actionExit()
		core.dashUses = 0
		return
	
	core.dashTimer -= _delta
	
	if Input.is_action_pressed("feint"):
		if core.isOnGround():
			machine.change_state("RollGround")
			return
		else:
			core.dashUses = 0
			machine.change_state("RollInAir")
			return
	
	if not core.isOnGround():
		core.velocity.y += core.CalcGravity() * _delta
	pass
