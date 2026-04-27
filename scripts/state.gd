extends Node
class_name State

var core : Player # TODO: Change this to core later so the script is more reusable
var machine : StateMachine

func enter() -> void:
	print(name, ' Enter')
	pass

func exit() -> void:
	print(name, ' Exit')
	pass

func physics_update(_delta: float) -> void:
	print(name, ' Update')
	pass
