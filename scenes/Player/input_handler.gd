extends MultiplayerSynchronizer
class_name InputHandler

#multiplayer inputs and other stuff with animations
#NOTE: for future me. i only need to pass inputs nothing else, no physics stuff
@export var movementDirection : float = 0
@export var lookDirection : float = 0
@export var runInput : bool = false
@export var crouchInput : bool = false
@export var blockInput : bool = false
@export var feintInput : bool = false
@export var dashInput : bool = false
@export var jumpInput : bool = false
@export var jumpInputUp : bool = false

@export var dash : bool = false
@export var jump : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	movementDirection = Input.get_axis("moveLeft", "moveRight")
	lookDirection = Input.get_axis("moveDown", "moveUp")
	runInput = Input.is_action_pressed("sprint")
	crouchInput = Input.is_action_pressed("crouch")
	blockInput = Input.is_action_pressed("block")
	feintInput = Input.is_action_pressed("feint")
	dashInput = Input.is_action_just_pressed("dash")
	jumpInput = Input.is_action_just_pressed("jump")
	jumpInputUp = Input.is_action_just_released("jump")
