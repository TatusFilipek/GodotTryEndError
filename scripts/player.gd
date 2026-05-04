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

var lastSpriteOrientation : bool
var facingDirection = 1

var sprite : AnimatedSprite2D

var jumping : bool = false

func _ready() -> void:
	sprite = get_node("AnimatedSprite2D")

# physics update
func _physics_process(delta: float) -> void:
	GetSpriteOrientation()
	move_and_slide()
	
	if is_on_floor():
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

#TODO:
	#add buffer timers to jumping (cayote time and jump input buffer)
	#add a camera that follows a player
	#add an enemy
	#add a core that all entities will have
	#before playing the animation check if the state needs to be changed

#NOTE:
	#if there is a bug that stops me whenever im jumping just like in the other game i made that means i have to remove the line that sets velocity to zero whenever i enter any idle state
	
