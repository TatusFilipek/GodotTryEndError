extends State
class_name Dash

var dashDirection : Vector2

func enter() -> void:
	super.enter()
	
	core.canChangeDir = false
	core.dashing = true
	
	core.dashCooldownTimer = core.dashCooldown
	core.dashUses -= 1
	
	dashDirection.x = core.MovementDirection()
	dashDirection.y = core.LookDirection()
	
	dashDirection = dashDirection.normalized()
	
	pass

func exit() -> void:
	super.exit()
	core.dashing = false
	core.canChangeDir = true
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	
	pass
