extends Node
class_name State

var core : Player 
var machine : StateMachine
var animationTree : AnimationTree
var playback : AnimationNodeStateMachinePlayback
var animationPlayer : AnimationPlayer

@onready var inputHandler: InputHandler = %InputHandler

var isActive

func Setup(_core : Player, _machine : StateMachine, _animationTree: AnimationTree, _playback : AnimationNodeStateMachinePlayback, _animationPlayer : AnimationPlayer) -> void:
	core = _core
	machine = _machine
	animationTree = _animationTree
	playback = _playback
	animationPlayer = _animationPlayer

func enter() -> void:
	print(name, ' Enter ', get_multiplayer_authority())
	isActive = true
	pass

func exit() -> void:
	print(name, ' Exit ', get_multiplayer_authority())
	isActive = false
	pass

func physics_update(_delta: float) -> void:
	pass
