extends State
class_name Dash

var dashDirection : Vector2
var playerPositionStart : Vector2
var playerPositionEnd : Vector2

func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	core.dashing = true
	
	core.dashCooldownTimer = core.dashCooldown
	core.dashUses -= 1
	core.dashTimer = core.dashDuration
	
	#fix direction calculation
	dashDirection.x = core.MovementDirection()
	dashDirection.y = core.LookDirection()
	
	#turn off player sticking to ground and such
	
	dashDirection = dashDirection.normalized()
	
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
		return
	else:
		core.dashTimer -= _delta
	
	if Input.is_action_pressed("feint"):
		machine.change_state("Roll")
		return
	pass
