extends CharacterBody2D

const MovementSpeed = 150
const gravityForce = 9.8
const weight = 1

const ALLMOVEMENTVARIABLE = 100

var velocitySandBox = Vector2.ZERO

#checking for input
func _input(event) -> void:
	if event.is_action_pressed("moveUp"):
		Jump()

# physics update
func _physics_process(delta: float) -> void:
	velocitySandBox.x = MovementDirection() * MovementSpeed
	if not is_on_floor():
		velocitySandBox += get_gravity() * delta;
	
	velocity.x = velocitySandBox.x * ALLMOVEMENTVARIABLE * delta
	move_and_slide()

func MovementDirection() -> float:
	var movementDirection = Input.get_axis("moveLeft", "moveRight")
	return movementDirection

func Jump() -> void:
	velocity.y = -500


#TODO:
	#Fix gravity
