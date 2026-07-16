extends Node
class_name State

var core : Player 
var machine : StateMachine
var animationTree : AnimationTree
var playback : AnimationNodeStateMachinePlayback
var animationPlayer : AnimationPlayer

var isActive

func Setup(_core : Player, _machine : StateMachine, _animationTree: AnimationTree, _playback : AnimationNodeStateMachinePlayback, _animationPlayer : AnimationPlayer) -> void:
	core = _core
	machine = _machine
	animationTree = _animationTree
	playback = _playback
	animationPlayer = _animationPlayer

func enter() -> void:
	print(name, ' Enter')
	isActive = true
	pass

func exit() -> void:
	print(name, ' Exit')
	isActive = false
	pass

func physics_update(_delta: float) -> void:
	pass
