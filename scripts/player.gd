extends CharacterBody2D

class_name Player

@export var MovementSpeed = 75
@export var sprintMovementMult = 1.5
@export var crouchMovementMult = .75

@export var slideForce = 250
@export var slideVelocityLoss = 100
@export var slideCancelVelocity = 40

@export var gravityForce = 100

@export var jumpForce = 150
@export var jumpVelocityCut = 0.3

@export var dashVelocity = 600
@export var dashCooldown = 1.5
@export var dashGroundUses = 2
@export var dashInAirUses = 1
@export var dashDuration = .3
var dashCooldownTimer = 0
var dashTimer = 0
var dashUses = 0

@export var rollVelocityLoss = 1200
@export var rollVelocityTreshold = 50

@export var normalGravityMult = 10.0
@export var fallingGravityMult = 20.2

@export var gravityBuffer = 50
@export var jumpApex = 125

@export var coyoteTime = .1
var coyoteTimer = 0

@export var jumpInputBuffer = .1
var jumpInputBufferTimer = 0

@export var ALLMOVEMENTVARIABLE = 100

@export var CheckWall : RayCast2D
@export var CheckLedge : RayCast2D
@export var CheckHead : RayCast2D
@export var CheckFloorFront : RayCast2D
@export var CheckFloorBack : RayCast2D
@export var CheckSpace : ShapeCast2D
@export var CheckSpaceCrouch : ShapeCast2D
@export var Collider : CollisionShape2D
@export var Sprite : AnimatedSprite2D

@onready var label : Label = $CanvasLayer/DebugHelper
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var animationTree : AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")

var lastSpriteOrientation : bool
var facingDirection = 1

var sprite : AnimatedSprite2D

var jumping : bool = false
var dashing : bool = false
var rolling : bool = false
var canChangeDir : bool = true

var spriteRotation : float

var ledgePosition : Vector2
var onLedgePosition : Vector2

var rollAnimFrame : float = 0

func _ready() -> void:
	sprite = get_node("AnimatedSprite2D")
	CheckLedge = get_node("CheckLedge")
	CheckWall = get_node("CheckWall")
	CheckHead = get_node("CheckHead")
	CheckSpace = get_node("CheckSpace")
	CheckSpaceCrouch = get_node("CheckSpaceCrouch")
	CheckFloorFront = get_node("CheckFloorFront")
	CheckFloorBack = get_node("CheckFloorBack")
	Collider = get_node("collider")
	Sprite = get_node("AnimatedSprite2D")

# physics update
func _physics_process(delta: float) -> void:
	GetSpriteOrientation()
	move_and_slide()
	
	label.text = "Animacja: %s | Klatka: %d" % [sprite.animation, sprite.frame]
	
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
	
	#Optimise this
	if dashCooldownTimer <= 0:
		if isOnGround():
			dashUses = dashGroundUses
		else:
			dashUses = dashInAirUses

func MovementDirection() -> float:
	var movementDirection = Input.get_axis("moveLeft", "moveRight")
	return movementDirection

func LookDirection() -> float:
	var lookDirection = Input.get_axis("moveUp", "moveDown")
	return lookDirection

func GetSpriteOrientation() -> void:

	if isOnGroundFully():
		spriteRotation = (CheckFloorFront.get_collision_point().y - CheckFloorBack.get_collision_point().y) * .03
		
		sprite.rotation = spriteRotation * facingDirection
		#sprite.rotate(spriteRotation * facingDirection)
	else:
		sprite.rotation = 0
		
	if canChangeDir:
		if MovementDirection() != 0:
			lastSpriteOrientation = (MovementDirection() < 0)
			facingDirection = ceil(MovementDirection())
		sprite.flip_h = lastSpriteOrientation
		
		if sign(CheckWall.target_position.x) != sign(facingDirection):
			CheckLedge.target_position.x *= -1
			CheckLedge.position.x *= -1
			CheckWall.target_position.x *= -1
			CheckWall.position.x *= -1
			CheckHead.target_position.x *= -1
			CheckHead.position.x *= -1
			CheckSpace.target_position.x *= -1
			CheckSpace.position.x *= -1
			CheckFloorFront.position.x *= -1
			CheckFloorBack.position.x *= -1

func IsLedgeDetected() -> bool:
	var collision : bool = isCollidingRaycast(CheckWall) and not isCollidingRaycast(CheckHead)
	
	if collision == true:
		SetLedgePosition()
	
	return collision

func IsSpaceToClimb() -> bool:
	return not isCollidingShapecast(CheckSpace)

func SetLedgePosition() -> void:
	#there is a bug where i jump from ledge to ledge and it doesnt set the new ledge position idk why
	#bug fixxed
	#NOTE: the couse of the bug was the length of the raycast. When checking for it the length must be the opposite of the offset for it to work correctly
	
	ledgePosition.x = CheckWall.get_collision_point().x
	ledgePosition.y = CheckLedge.get_collision_point().y
	
	onLedgePosition = SetLedgeOffset(ledgePosition)

func SetLedgeOffset(ledgePos : Vector2) -> Vector2:
	#Player-Ledge offset idk how to calculate it smarter, will probably need to be fixxed later
	ledgePos.x -= CheckWall.position.x
	ledgePos.y -= CheckLedge.position.y
	
	return ledgePos

func isOnGround() -> bool:
	return is_on_floor() and (isCollidingRaycast(CheckFloorBack) or isCollidingRaycast(CheckFloorFront))

func isOnGroundFully() -> bool:
	return is_on_floor_only() and isCollidingRaycast(CheckFloorFront) and isCollidingRaycast(CheckFloorBack)

func CalcGravity() -> float:
	var gravityMultiplier = normalGravityMult
	if not isOnGround():
		if(velocity.y <= -gravityBuffer): gravityMultiplier = normalGravityMult
		else: if(velocity.y > -gravityBuffer): gravityMultiplier = fallingGravityMult
		
	return gravityMultiplier * gravityForce + velocity.y * gravityMultiplier/100

func isCollidingRaycast(raycast : RayCast2D) -> bool:
	raycast.force_raycast_update()
	raycast.force_update_transform()
	
	return raycast.is_colliding()

func isCollidingShapecast(shapecast : ShapeCast2D) -> bool:
	shapecast.force_shapecast_update()
	shapecast.force_update_transform()
	
	return shapecast.is_colliding()

#TODO:
	#resize collider when crouching
	#add more ifs for changing states
	#add an enemy
	#add a core that all entities will have

#NOTE:
	#if there is a bug that stops me whenever im jumping just like in the other game i made that means i have to remove the line that sets velocity to zero whenever i enter any idle state
