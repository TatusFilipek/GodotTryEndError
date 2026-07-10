extends State
class_name Action

@export var walkSpeedMultiplier: float
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
	
	#proper collider sizing
	if not core.isCollidingShapecast(core.CheckSpaceCrouch) and not Input.is_action_pressed("crouch"):
		core.resizeCollider(0)
		core.isCrouching = false
	
	#jumping
	if canJump and core.CanJump() and not core.isCollidingShapecast(core.CheckSpaceCrouch):
		core.coyoteTimer = 0
		core.jumpInputBufferTimer = 0
		core.velocity.y = core.jumpForce
		core.jumping = true
		
	#off ground physics
	if not core.isOnGround():
		core.velocity.y -= core.CalcGravity() * _delta; # Gravity
		
		if core.MovementDirection() != 0:
			if abs(core.velocity.x) < maxMovementSpeed:
				core.velocity.x += (maxMovementSpeed * core.facingDirection * core.airDrag * 1) * _delta
			else:
				core.velocity.x -= core.velocity.x * core.airDrag * .5 * _delta
		
		VariableJumpHeight()
	#ground physics
	else:
		core.velocity.x = core.MovementDirection() * core.MovementSpeed
	
	#check for hits, if hit then disable current attack collisions for said object, player whatever
	pass

func feint():
	if not canFeint: return
	#apply endlag, then exit
	machine.actionExit()
	pass

func VariableJumpHeight():
	if core.velocity.y <= 0:
		core.jumping = false
	
	if core.jumping and Input.is_action_just_released("jump"):
		core.velocity.y *= core.jumpVelocityCut
