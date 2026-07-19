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
@export var dashCooldownTimer = 0
@export var dashUses = 0

@export var rollVelocityLoss = 12.00
@export var rollVelocityTreshold = .50

@export var normalGravityMult = 10.0
@export var fallingGravityMult = 20.2

@export var gravityBuffer = .50
@export var jumpApex = 5

@export var coyoteTime = .1
@export var coyoteTimer = 0

@export var jumpInputBuffer = .1
@export var jumpInputBufferTimer = 0

@export var parryCooldown = 2
@export var parryTimer = 0

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

#@export var LookAtTarget : Node3D

# Instead of managing a single flat AnimatedSprite2D, we will rotate a parent 3D Visuals node.
# Put your 3D Mesh and your AnimationPlayer/AnimationTree inside a Node3D wrapper called "Visuals"
@export var VisualsNode : Node3D

@onready var label : Label = $CanvasLayer/Control/DebugHelper
@onready var dashCooldownIcon : TextureRect = $CanvasLayer/Control/Cooldowns/DashIcon
@onready var parryCooldownIcon : TextureRect = $CanvasLayer/Control/Cooldowns/ParryIcon
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var animationTree : AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
@onready var machine : StateMachine = $StateMachine
@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var name_plate: Label3D = %NamePlate
@onready var camera: Camera3D = %Camera
@onready var menu: HBoxContainer = %Menu
@onready var exit: Button = %Exit

@export var lastSpriteOrientation : bool
@export var facingDirection = 1

var jumping : bool = false
@export var dashing : bool = false
@export var rolling : bool = false
@export var isCrouching : bool = false
var canChangeDir : bool = true
@export var blocking : bool = false
@export var parrying : bool = false

var spriteRotation : float

# Position values handle 3D coordinates
var ledgePosition : Vector3
var onLedgePosition : Vector3
var visualNodeStartRotation : Vector3

var rollAnimFrame : float = 0

@export var Hotbar : Dictionary[String, State]
var hotbarItems : int = 0

@onready var inputHandler: InputHandler = %InputHandler

@export var velocitySandbox : Vector3

@export var canParry : bool
@export var canDash : bool
@export var canJump : bool

@export var dash : bool

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

func _ready() -> void:
	add_to_group('Players')
	name_plate.text = name
	
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
	
	AddToHotbar("Action")
	AddToHotbar("Action2")
	
	#collision exeption
	var players: Array[Node] = get_tree().get_nodes_in_group('Players')
	for others in players:
		if others.name != name: add_collision_exception_with(others)
	
	if is_multiplayer_authority():
		camera.current = true
		menu.hide()
		exit.pressed.connect(func(): Network.leave_server())
		#TODO: add this if statement in state machine
		#NOTE: i know how to make the animations work on the server. I think the server doesnt recieve inputs so the statemachine just doesnt update, i need to pass inputs and collisions then everything will work properly
	else:
		canvas_layer.visible = false

func _process(delta: float) -> void:	
	#UI
	if machine.current_state:
		# Note: modified sprite.animation references to string placeholders or custom debug names if applicable.
		label.text = "Stan: %s | XVelocity: %f | YVelocity: %f | movementDir: %f | lookDir: %f" % [machine.current_state.name, velocitySandbox.x, velocitySandbox.y, inputHandler.movementDirection, inputHandler.lookDirection]
	
	if CanDash():
		dashCooldownIcon.self_modulate = Color("b9b9b9")
	else:
		dashCooldownIcon.self_modulate = Color("4e4e4eff")
	
	if CanParry():
		parryCooldownIcon.self_modulate = Color("b9b9b9")
	else:
		parryCooldownIcon.self_modulate = Color("4e4e4eff")
	
	if Input.is_action_just_pressed("menu") and menu.visible == false:
		menu.show()
	elif Input.is_action_just_pressed("menu") and menu.visible:
		menu.hide()
	
	#Timers
	TickTimers(delta)
	
	canDash = CanDash()
	canParry = CanParry()
	canJump = CanJump()
	
	#dash uses
	if dashCooldownTimer <= 0 and dashUses <= dashGroundUses:
		if isOnGround():
			dashUses = dashGroundUses
		else:
			dashUses = dashInAirUses

# physics update
func _physics_process(delta: float) -> void:
	GetSpriteOrientation(delta)
	
	# CRITICAL 2.5D MECHANIC: Lock Z positioning completely to avoid drifting down or up depth paths
	velocitySandbox.z = 0.0
	global_transform.origin.z = 0.0
	
	velocity = velocitySandbox
	#if not is_multiplayer_authority(): return
	move_and_slide()

func TickTimers(delta:float) -> void:
	#Timers
	parryTimer -= delta
	
	if isOnGround() or IsLedgeDetected():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta
		
	if inputHandler.jumpInput:
		jumpInputBufferTimer = jumpInputBuffer
	else:
		jumpInputBufferTimer -= delta
	
	if not dashing and not rolling:
		dashCooldownTimer -= delta

func AddToHotbar(stateName: String) -> void:
	var desiredState = machine.GetState(stateName)
	
	hotbarItems += 1
	
	if desiredState is Action:
		Hotbar["hb" + str(hotbarItems)] = desiredState
		inputHandler.hotbarInputs["hb" + str(hotbarItems)] = false
	pass

func GetSpriteOrientation(delta: float) -> void:
	if isOnGroundFully():
		# Using Y positions of 3D floor contact raycasts to calculate slope inclination angles
		spriteRotation = (CheckFloorFront.get_collision_point().y - CheckFloorBack.get_collision_point().y) * -3
		VisualsNode.rotation.x = spriteRotation
	else:
		VisualsNode.rotation.x = 0
		#NOTE: in future use tween for smother transition
	
	if canChangeDir:
		if inputHandler.movementDirection != 0:
			lastSpriteOrientation = (inputHandler.movementDirection < 0)
			facingDirection = ceil(inputHandler.movementDirection)
		
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
	return is_on_floor()
	#return is_on_floor() and (isCollidingRaycast(CheckFloorBack) or isCollidingRaycast(CheckFloorFront))
	#return isCollidingRaycast(CheckFloorFront) and isCollidingRaycast(CheckFloorBack)

func isOnGroundFully() -> bool:
	#return is_on_floor()
	return is_on_floor() and isCollidingRaycast(CheckFloorFront) and isCollidingRaycast(CheckFloorBack)
	#return isCollidingRaycast(CheckFloorFront) and isCollidingRaycast(CheckFloorBack)

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
		if(velocitySandbox.y <= -gravityBuffer): gravityMultiplier = normalGravityMult
		else: if(velocitySandbox.y > -gravityBuffer): gravityMultiplier = fallingGravityMult
		
	#return get_gravity().y
	return gravityMultiplier * gravityForce + velocitySandbox.y * gravityMultiplier/100

func CanJump() -> bool:
	return jumpInputBufferTimer > 0 and coyoteTimer > 0

func CanParry() -> bool:
	return parryTimer < 0

func CanDash() -> bool:
	return (dashCooldownTimer <= 0 or dashUses > 0) and not dashing and not rolling

func isCollidingRaycast(raycast : RayCast3D) -> bool:
	raycast.force_raycast_update()
	raycast.force_update_transform()
	return raycast.is_colliding()

func isCollidingShapecast(shapecast : ShapeCast3D) -> bool:
	shapecast.force_shapecast_update()
	shapecast.force_update_transform()
	return shapecast.is_colliding()
	
#NOTE: im thinking of adding a second state machine that will check for semi states like parry, block, emotes, attacks, stuns, dazes, guardbreaks, knockdowns. Rethinking that it would be kinda pointless. from parry to attacks i could make them an actions but the rest idk, i will cross that bridge when i get there.
#i will have to remake the animation tree so i can blend animations together, and have overlapping anims
#i can have it so the player class sends an action event certain state will get the event and change to the desired state
#i can add a semiparry that will be used during ledge climb/grab but i dont think it is necessary
