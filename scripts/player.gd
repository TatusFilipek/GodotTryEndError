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
@export var Collider : CollisionShape2D

var lastSpriteOrientation : bool
var facingDirection = 1

var sprite : AnimatedSprite2D

var jumping : bool = false

func _ready() -> void:
	sprite = get_node("AnimatedSprite2D")
	CheckLedge = get_node("CheckLedge")
	CheckWall = get_node("CheckWall")
	Collider = get_node("collider")

# physics update
func _physics_process(delta: float) -> void:
	GetSpriteOrientation()
	move_and_slide()
	
	if is_on_floor() or IsLedgeDetected():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta
		
	if Input.is_action_just_pressed("moveUp"):
		jumpInputBufferTimer = jumpInputBuffer
	else:
		jumpInputBufferTimer -= delta

func MovementDirection() -> float:
	var movementDirection = Input.get_axis("moveLeft", "moveRight")
	return movementDirection
	
func GetSpriteOrientation() -> void:
	if MovementDirection() != 0:
		lastSpriteOrientation = (MovementDirection() < 0)
		facingDirection = ceil(MovementDirection())
	sprite.flip_h = lastSpriteOrientation
	
	if sign(CheckWall.target_position.x) != sign(facingDirection):
		CheckLedge.target_position.x *= -1
		CheckLedge.position.x *= -1
		CheckWall.target_position.x *= -1
		CheckWall.position.x *= -1

func IsLedgeDetected() -> bool:
	return CheckWall.is_colliding() and not CheckLedge.is_colliding()

func GetLedgePosition() -> Vector2:
	var ledgePos : Vector2
	
	#there is a bug where i jump from ledge to ledge and it doesnt set the new ledge position idk why
	#bug fixxed
	#NOTE: the couse of the bug was the length of the raycast. When checking for it the length must be the opposite of the offset for it to work correctly
	
	ledgePos.x = CheckWall.get_collision_point().x
	ledgePos.y = CheckLedge.get_collision_point().y
	
	#Player-Ledge offset idk how to calculate it smarter, will probably need to be fixxed later
	ledgePos.x -= CheckWall.position.x
	ledgePos.y -= CheckLedge.position.y
	
	print(ledgePos)
	
	return ledgePos

#TODO:
	#add ledge grab and ledge climb
	#add dashing or rolling i will decide later
	#add a camera that follows a player
	#add an enemy
	#add a core that all entities will have
	#before playing the animation check if the state needs to be changed

#NOTE:
	#if there is a bug that stops me whenever im jumping just like in the other game i made that means i have to remove the line that sets velocity to zero whenever i enter any idle state
	#rolling when crouching or idle and dashing in every other state
