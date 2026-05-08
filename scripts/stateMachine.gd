extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State
var lastState : State

var parent : Player

func _ready() -> void:
	parent = get_parent()
	var sprite = parent.get_node("AnimatedSprite2D")
	var animationTree = parent.get_node("AnimationTree")
	var playback = animationTree.get("parameters/playback")
	var animationPlayer = parent.get_node("AnimationPlayer")
	
	for child in get_children():
		if child is State:
			child.Setup(parent, self, sprite, animationTree, playback, animationPlayer)
	
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
		if parent.isCollidingShapecast(parent.CheckSpaceCrouch):
			change_state("CrouchIdle")
		else:
			change_state("Idle")
	else:
		change_state("FallIdle")

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
