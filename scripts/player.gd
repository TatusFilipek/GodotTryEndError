extends CharacterBody2D

class_name Player

@export var MovementSpeed = 150
@export var gravityForce = 100

@export var jumpForce = 150

@export var normalGravityMult = 10.0
@export var fallingGravityMult = 20.2
var gravityMultiplier = normalGravityMult

@export var gravityBuffer = 50

@export var ALLMOVEMENTVARIABLE = 100

# physics update
func _physics_process(delta: float) -> void:
	move_and_slide()

func MovementDirection() -> float:
	var movementDirection = Input.get_axis("moveLeft", "moveRight")
	return movementDirection

#func Jump() -> void:
	#velocity.y = -jumpForce * transform.get_scale().y * 3

func CalcGravity() -> float:
	gravityMultiplier = normalGravityMult
	if not is_on_floor():
		if(velocity.y <= -gravityBuffer): gravityMultiplier = normalGravityMult
		else: if(velocity.y > -gravityBuffer): gravityMultiplier = fallingGravityMult
		
	return gravityMultiplier * gravityForce + velocity.y * gravityMultiplier/100

#TODO:
	#add a camera that follows a player
	#add an enemy
	#add a core that all entities will have

#NOTE:
	#if there is a bug that stops me whenever im jumping just like in the other game i made that means i have to remove the line that sets velocity to zero whenever i enter any idle state
	
