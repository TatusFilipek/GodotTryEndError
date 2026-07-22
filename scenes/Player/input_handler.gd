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
@export var jumpInputDown : bool = false

@export var hotbarInputs : Dictionary[String, bool]

@export var interact : bool = false
@export var interactHold : bool = false

@export var weaponOutInput : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_multiplayer_authority():
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movementDirection = Input.get_axis("moveLeft", "moveRight")
	lookDirection = Input.get_axis("moveDown", "moveUp")
	runInput = Input.is_action_pressed("sprint")
	crouchInput = Input.is_action_pressed("crouch")
	blockInput = Input.is_action_pressed("block")
	feintInput = Input.is_action_pressed("feint")
	dashInput = Input.is_action_just_pressed("dash")
	jumpInput = Input.is_action_pressed("jump")
	jumpInputUp = not Input.is_action_pressed("jump")
	jumpInputDown = Input.is_action_just_pressed("jump")
	
	interact = Input.is_action_just_pressed("interact")
	interactHold = Input.is_action_pressed("interact")
	
	weaponOutInput = Input.is_action_just_pressed("weapon")
	
	for action in hotbarInputs:
		#if Input.is_action_just_pressed(action):
			#hotbarInputs[action] = true
		hotbarInputs[action] = Input.is_action_just_pressed(action)
