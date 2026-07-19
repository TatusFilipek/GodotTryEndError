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

func change_state(new_state_name: String) -> void:
	var newState = get_node(new_state_name)
	
	if current_state:
		current_state.exit()
	
	lastState = current_state
	current_state = newState
	current_state.enter()

func actionExit() -> void:
	if parent.isOnGround():
		if parent.isCollidingShapecast(parent.CheckSpaceCrouch) or inputHandler.crouchInput:
			ChangeStateMoveOrIdle("CrouchIdle", "CrouchWalk")
		else:
			ChangeStateMoveOrIdle("Idle", "Walk")
	else:
		ChangeStateMoveOrIdle("FallIdle", "FallMove")

func ChangeStateMoveOrIdle(idleStateName : String, moveStateName : String) -> void:
	if inputHandler.movementDirection != 0:
		change_state(moveStateName)
	else:
		change_state(idleStateName)

func GetState(_StateName: String) -> State:
	var stateOut: State
	
	for state in states:
		if state.name == _StateName:
			stateOut = state
	
	return stateOut

#NOTE: the thing is the that is a physics update, it updates if something changes, and on the server side there isnt any inputs so it doesnt update properly
func _process(delta: float) -> void:
	#if not multiplayer.is_server(): return
	#TODO: make all calculations server side, only input should be on the players side
	if current_state:
		current_state.physics_update(delta)
		curentState.text = current_state.name
