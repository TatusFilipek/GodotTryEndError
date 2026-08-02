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
var feintable : bool = false

func enter():
	super.enter()
	#check if animation exist
	playback.travel(animationName)
	core.canChangeDir = canChangeDir
	maxMovementSpeed = core.MovementSpeed * walkSpeedMultiplier
	feintable = canFeint
	pass

func attackEnter():
	super.enter()
	core.canChangeDir = canChangeDir
	maxMovementSpeed = core.MovementSpeed * walkSpeedMultiplier
	feintable = canFeint

func exit():
	#apply endlag if needed before super.exit so it the state doesnt get disabled
	super.exit()
	core.canChangeDir = true
	pass

func physics_update(_delta: float):
	super.physics_update(_delta)
	
	#feint
	if canFeint and inputHandler.feintInput and feintable:
		rpc("feint")
		return
	
	#if hit, stunned, dazed return
	
	#proper collider sizing
	if not core.isCollidingShapecast(core.check_space_crouch) and not inputHandler.crouchInput:
		core.resizeCollider(0)
		core.isCrouching = false
	
	#jumping
	if canJump and core.CanJump() and not core.isCollidingShapecast(core.check_space_crouch):
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		core.velocitySandbox.y = core.jumpForce
		core.jumping = true
		
	#off ground physics
	if not core.isOnGround():
		core.velocitySandbox.y -= core.CalcGravity() * _delta; # Gravity
		
		if core.direction:
			if abs(core.velocitySandbox.x) <= maxMovementSpeed:
				core.velocitySandbox.x = move_toward(core.velocitySandbox.x, maxMovementSpeed * core.direction.x, core.airDrag * _delta)
				core.velocitySandbox.z = move_toward(core.velocitySandbox.z, maxMovementSpeed * core.direction.z, core.airDrag * _delta)
			else:
				core.velocitySandbox.x = move_toward(core.velocitySandbox.x, 0, core.airDrag * _delta)
				core.velocitySandbox.z = move_toward(core.velocitySandbox.z, 0, core.airDrag * _delta)
		
		VariableJumpHeight()
	#ground physics
	else:
		core.velocitySandbox.x = core.direction.x * maxMovementSpeed
		core.velocitySandbox.z = core.direction.z * maxMovementSpeed
	
	#check for hits, if hit then disable current attack collisions for said object, player whatever
	pass

@rpc("any_peer", "call_local", "reliable", -2)
func feint():
	if not canFeint: return
	#playsound, add visuals, apply endlag, then exit
	switch_state()
	pass

func EndAction():
	switch_state()

func switch_state():
	machine.actionExit()

func VariableJumpHeight():
	if core.velocitySandbox.y <= 0:
		core.jumping = false
	
	if core.jumping and inputHandler.jumpInputUp:
		core.velocitySandbox.y *= core.jumpVelocityCut
