extends CharacterBody2D

const MovementSpeed = 150
const gravityForce = 100

const jumpForce = 150

const normalGravityMult = 10.0
const fallingGravityMult = 20.2
var gravityMultiplier = normalGravityMult

const gravityBuffer = 50

const ALLMOVEMENTVARIABLE = 100

var velocitySandBox = Vector2.ZERO

#checking for input
func _input(event) -> void:
	if event.is_action_pressed("moveUp"):
		Jump()

# physics update
func _physics_process(delta: float) -> void:
	velocity.x = MovementDirection() * MovementSpeed * delta
	
	if not is_on_floor():
		velocity.y += CalcGravity() * delta;
	
	velocity.x *= ALLMOVEMENTVARIABLE
	move_and_slide()

func MovementDirection() -> float:
	var movementDirection = Input.get_axis("moveLeft", "moveRight")
	return movementDirection

func Jump() -> void:
	velocity.y = -jumpForce * transform.get_scale().y * 3

func CalcGravity() -> float:
	gravityMultiplier = normalGravityMult
	if not is_on_floor():
		if(velocity.y <= -gravityBuffer): gravityMultiplier = normalGravityMult
		else: if(velocity.y > -gravityBuffer): gravityMultiplier = fallingGravityMult
		
	print(velocity.y)
	return gravityMultiplier * gravityForce + velocity.y * gravityMultiplier/100

#TODO:
	#Tinker with the gravity and jump force
	#make a statemachine
	#add a camera that follows a player
	#add an enemy
