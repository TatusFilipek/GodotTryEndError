extends State
class_name Dash

var dashDirection : Vector2
var playerPositionStart : Vector2
var playerPositionEnd : Vector2

#TODO: fix being able to use dash twice while in the air when dashing from ground

func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	core.dashing = true
	
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
	print(dashDirection)
	
	core.velocity = dashDirection * core.dashVelocity
	
	pass

func exit() -> void:
	super.exit()
	core.dashing = false
	core.canChangeDir = true
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if core.dashTimer <= 0:
		machine.change_state("Idle")
		core.dashUses = 0
		return
	
	core.dashTimer -= _delta
	
	if Input.is_action_pressed("feint"):
		machine.change_state("Roll")
		return
	
	if not core.is_on_floor() and not core.CheckFloorFront.is_colliding() and not core.CheckFloorBack.is_colliding():
		core.velocity.y += core.CalcGravity() * _delta
	pass
