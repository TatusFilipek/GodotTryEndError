extends Node
class_name State

var core : Player # TODO: Change this to core later so the script is more reusable
var machine : StateMachine
var animation : AnimatedSprite2D
var animationTree : AnimationTree
var playback : AnimationNodeStateMachinePlayback

func Setup(_core : Player, _machine : StateMachine, _animation : AnimatedSprite2D, _animationTree: AnimationTree, _playback : AnimationNodeStateMachinePlayback) -> void:
	core = _core
	machine = _machine
	animation = _animation
	animationTree = _animationTree
	playback = _playback

func enter() -> void:
	print(name, ' Enter')
	#playback.travel(name)
	pass

func exit() -> void:
	print(name, ' Exit')
	pass

func physics_update(_delta: float) -> void:
	#print(name, ' Update')
	pass
