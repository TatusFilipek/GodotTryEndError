extends CharacterBody3D

class_name Player

@export var MovementSpeed = 1.00
@export var sprintMovementMult = 3.5
@export var crouchMovementMult = .75

@export var slideForce = 3.5
@export var slideVelocityLoss = 1.00
@export var slideCancelVelocity = .40

@export var gravityForce = 1.75
@export var airDrag = 20

@export var jumpForce = 10
@export var jumpVelocityCut = 0.3

@export var dashVelocity = 7.00
@export var dashCooldown = 1.5
@export var dashGroundUses = 2
@export var dashInAirUses = 1
@export var dashDuration = .2
var dashCooldownTimer = 0
var dashTimer = 0
var dashUses = 0

@export var rollVelocityLoss = 12.00
@export var rollVelocityTreshold = .50

@export var normalGravityMult = 10.0
@export var fallingGravityMult = 20.2

@export var gravityBuffer = .50
@export var jumpApex = 5

@export var coyoteTime = .1
var coyoteTimer = 0

@export var jumpInputBuffer = .1
var jumpInputBufferTimer = 0

@export var ALLMOVEMENTVARIABLE = 100

# RayCast2D and ShapeCast2D nodes are upgraded to RayCast3D and ShapeCast3D
@export var CheckWallTop : RayCast3D
@export var CheckWallBottom : RayCast3D
@export var CheckLedge : RayCast3D
@export var CheckHead : RayCast3D
@export var CheckFloorFront : RayCast3D
@export var CheckFloorBack : RayCast3D
@export var CheckSpace : ShapeCast3D
@export var CheckSpaceCrouch : ShapeCast3D
@export var Collider : CollisionShape3D

# Instead of managing a single flat AnimatedSprite2D, we will rotate a parent 3D Visuals node.
# Put your 3D Mesh and your AnimationPlayer/AnimationTree inside a Node3D wrapper called "Visuals"
@export var VisualsNode : Node3D

@onready var label : Label = $CanvasLayer/DebugHelper
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var animationTree : AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
@onready var machine : StateMachine = $StateMachine

var lastSpriteOrientation : bool
var facingDirection = 1

var jumping : bool = false
var dashing : bool = false
var rolling : bool = false
var isCrouching : bool = false
var canChangeDir : bool = true

var spriteRotation : float

# Position values handle 3D coordinates
var ledgePosition : Vector3
var onLedgePosition : Vector3
var visualNodeStartRotation : Vector3

var rollAnimFrame : float = 0

func _ready() -> void:
	CheckLedge = get_node("CheckLedge")
	CheckWallTop = get_node("CheckWallTop")
	CheckWallBottom = get_node("CheckWallBottom")
	CheckHead = get_node("CheckHead")
	CheckSpace = get_node("CheckSpace")
	CheckSpaceCrouch = get_node("CheckSpaceCrouch")
	CheckFloorFront = get_node("CheckFloorFront")
	CheckFloorBack = get_node("CheckFloorBack")
	Collider = get_node("collider")
	VisualsNode = get_node("Armature")
	visualNodeStartRotation = VisualsNode.rotation_degrees

# physics update
func _physics_process(delta: float) -> void:
	GetSpriteOrientation(delta)
	
	# CRITICAL 2.5D MECHANIC: Lock Z positioning completely to avoid drifting down or up depth paths
	velocity.z = 0.0
	global_transform.origin.z = 0.0
	
	move_and_slide()
	
	if machine.current_state:
		# Note: modified sprite.animation references to string placeholders or custom debug names if applicable.
		label.text = "Stan: %s | XVelocity: %f | YVelocity: %f | movementDir: %f | lookDir: %f" % [machine.current_state.name, velocity.x, velocity.y, MovementDirection(), LookDirection()]
	
	if isOnGround() or IsLedgeDetected():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta
		
	if Input.is_action_just_pressed("jump"):
		jumpInputBufferTimer = jumpInputBuffer
	else:
		jumpInputBufferTimer -= delta
	
	if not dashing and not rolling:
		dashCooldownTimer -= delta
	
	if dashCooldownTimer <= 0 and dashUses <= dashGroundUses:
		if isOnGround():
			dashUses = dashGroundUses
		else:
			dashUses = dashInAirUses

func MovementDirection() -> float:
	var movementDirection = Input.get_axis("moveLeft", "moveRight")
	return movementDirection

func LookDirection() -> float:
	var lookDirection = Input.get_axis("moveDown", "moveUp")
	return lookDirection

func GetSpriteOrientation(delta: float) -> void:
	if isOnGroundFully():
		# Using Y positions of 3D floor contact raycasts to calculate slope inclination angles
		spriteRotation = (CheckFloorFront.get_collision_point().y - CheckFloorBack.get_collision_point().y) * -3
		VisualsNode.rotation.x = spriteRotation
	else:
		VisualsNode.rotation.x = 0
		#in future use tween for smother transition
		
	if canChangeDir:
		if MovementDirection() != 0:
			lastSpriteOrientation = (MovementDirection() < 0)
			facingDirection = ceil(MovementDirection())
		
		if lastSpriteOrientation:
			VisualsNode.rotation_degrees.y = 180.0 + visualNodeStartRotation.y
		else:
			VisualsNode.rotation_degrees.y = 0.0 + visualNodeStartRotation.y
		
		if sign(CheckWallTop.target_position.x) != sign(facingDirection):
			CheckLedge.target_position.x *= -1
			CheckLedge.position.x *= -1
			CheckWallTop.target_position.x *= -1
			CheckWallTop.position.x *= -1
			CheckWallBottom.target_position.x *= -1
			CheckWallBottom.position.x *= -1
			CheckHead.target_position.x *= -1
			CheckHead.position.x *= -1
			CheckSpace.target_position.x *= -1
			CheckSpace.position.x *= -1
			CheckFloorFront.position.x *= -1
			CheckFloorBack.position.x *= -1

func IsLedgeDetected() -> bool:
	var collision : bool = isCollidingRaycast(CheckWallTop) and not isCollidingRaycast(CheckHead)
	
	if collision == true:
		SetLedgePosition()
	
	return collision

func IsSpaceToClimb() -> bool:
	return not isCollidingShapecast(CheckSpace)

func SetLedgePosition() -> void:
	ledgePosition.x = CheckWallTop.get_collision_point().x
	ledgePosition.y = CheckLedge.get_collision_point().y
	# Ensure Z matches character baseline
	ledgePosition.z = 0.0
	
	onLedgePosition = SetLedgeOffset(ledgePosition)

func SetLedgeOffset(ledgePos : Vector3) -> Vector3:
	ledgePos.x -= CheckWallTop.position.x
	ledgePos.y -= CheckLedge.position.y
	return ledgePos

func isOnGround() -> bool:
	# Godot 3D safely checks is_on_floor()
	#return is_on_floor()
	return is_on_floor() and (isCollidingRaycast(CheckFloorBack) or isCollidingRaycast(CheckFloorFront))

func isOnGroundFully() -> bool:
	#return is_on_floor()
	return is_on_floor() and isCollidingRaycast(CheckFloorFront) and isCollidingRaycast(CheckFloorBack)

func isOnWall() -> bool:
	#return is_on_wall()
	return isCollidingRaycast(CheckWallTop)

func resizeCollider(_size : float) -> void:
	# Resizes 3D Capsule or Box height parameters safely
	if Collider.shape.has_method("set_height"):
		Collider.shape.set_height(1.8 - _size)
	Collider.position.y = (1.8 - _size) / 2

func CalcGravity() -> float:
	var gravityMultiplier = normalGravityMult
	if not isOnGround():
		if(velocity.y <= -gravityBuffer): gravityMultiplier = normalGravityMult
		else: if(velocity.y > -gravityBuffer): gravityMultiplier = fallingGravityMult
		
	#return get_gravity().y
	return gravityMultiplier * gravityForce + velocity.y * gravityMultiplier/100

func CanJump() -> bool:
	return jumpInputBufferTimer > 0 and coyoteTimer > 0

func isCollidingRaycast(raycast : RayCast3D) -> bool:
	#raycast.force_raycast_update()
	#raycast.force_update_transform()
	return raycast.is_colliding()

func isCollidingShapecast(shapecast : ShapeCast3D) -> bool:
	#shapecast.force_shapecast_update()
	#shapecast.force_update_transform()
	return shapecast.is_colliding()
