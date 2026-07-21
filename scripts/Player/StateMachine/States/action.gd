extends State
class_name Action

@export var walkSpeedMultiplier: float
@export var endLag: float
@export var endLagFeint: float

@export var canJump: bool
@export var canChangeDir: bool
@export var canFeint: bool

@export var animationName: String

var maxMovementSpeed: float

func enter():
	super.enter()
	#check if animation exist
	playback.travel(animationName)
	core.canChangeDir = canChangeDir
	maxMovementSpeed = core.MovementSpeed * walkSpeedMultiplier
	pass

func exit():
	#apply endlag if needed before super.exit so it the state doesnt get disabled
	super.exit()
	core.canChangeDir = true
	pass

func physics_update(_delta: float):
	super.physics_update(_delta)
	
	#feint
	if canFeint and inputHandler.feintInput:
		rpc("feint")
		return
	
	#if hit, stunned, dazed return
	
	#proper collider sizing
	if not core.isCollidingShapecast(core.CheckSpaceCrouch) and not inputHandler.crouchInput:
		core.resizeCollider(0)
		core.isCrouching = false
	
	#jumping
	if canJump and core.CanJump() and not core.isCollidingShapecast(core.CheckSpaceCrouch):
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		core.velocitySandbox.y = core.jumpForce
		core.jumping = true
		
	#off ground physics
	if not core.isOnGround():
		core.velocitySandbox.y -= core.CalcGravity() * _delta; # Gravity
		
		if inputHandler.movementDirection != 0:
			if abs(core.velocitySandbox.x) <= maxMovementSpeed:
				core.velocitySandbox.x += (maxMovementSpeed * inputHandler.movementDirection * core.airDrag * 1) * _delta
				core.velocitySandbox.x = clamp(core.velocitySandbox.x, -maxMovementSpeed, maxMovementSpeed)
			else:
				core.velocitySandbox.x -= core.velocitySandbox.x * core.airDrag * .5 * _delta
		
		VariableJumpHeight()
	#ground physics
	else:
		core.velocitySandbox.x = inputHandler.movementDirection * maxMovementSpeed
	
	#check for hits, if hit then disable current attack collisions for said object, player whatever
	pass

@rpc("any_peer", "call_local", "reliable", -2)
func feint():
	if not canFeint: return
	#playsound, add visuals, apply endlag, then exit
	machine.actionExit()
	pass

func EndAction():
	core.weapon.attackFinished.emit()
	switch_state()

func switch_state():
	machine.rpc("change_state", "Idle")

func VariableJumpHeight():
	if core.velocitySandbox.y <= 0:
		core.jumping = false
	
	if core.jumping and inputHandler.jumpInputUp:
		core.velocitySandbox.y *= core.jumpVelocityCut
