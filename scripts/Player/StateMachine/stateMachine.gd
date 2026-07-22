extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State
var lastState : State

var parent : Player

@onready var states = self.get_children()
@onready var inputHandler: InputHandler = %InputHandler
@onready var curentState: Label3D = %CurentState

func _ready() -> void:
	parent = get_parent()
	var animationTree = parent.get_node("AnimationTree")
	var playback = animationTree.get("parameters/playback")
	var animationPlayer = parent.get_node("AnimationPlayer")
	
	for child in get_children():
		if child is State:
			# Removed outdated reference to 2D flat texturing elements inside Setup
			child.Setup(parent, self, animationTree, playback, animationPlayer)
	
	if initial_state:
		change_state(initial_state.name)
	
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)

@rpc("authority", "call_local", "reliable", 0)
func change_state(new_state_name: String) -> void:
	var newState = get_node(new_state_name)
	
	if current_state:
		current_state.exit()
	
	lastState = current_state
	current_state = newState
	current_state.enter()

func actionExit() -> void:
	if parent.isOnGround():
		if parent.isCollidingShapecast(parent.check_space_crouch) or inputHandler.crouchInput:
			ChangeStateMoveOrIdle("CrouchIdle", "CrouchWalk")
		else:
			ChangeStateMoveOrIdle("Idle", "Walk")
	else:
		ChangeStateMoveOrIdle("FallIdle", "FallMove")

func ChangeStateMoveOrIdle(idleStateName : String, moveStateName : String) -> void:
	if inputHandler.movementDirection != 0:
		rpc("change_state", moveStateName)
	else:
		rpc("change_state", idleStateName)

func GetState(_StateName: String) -> State:
	var stateOut: State
	
	for state in states:
		if state.name == _StateName:
			stateOut = state
	
	return stateOut

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
