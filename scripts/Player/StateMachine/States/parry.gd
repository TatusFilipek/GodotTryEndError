extends Action
class_name Parry

@export var parryWindow: float = .3
var parryWindowTimer: float = 0

func enter():
	super.enter()
	
	core.parrying = true
	parryWindowTimer = 0
	core.parryTimer = core.parryCooldown
	pass

func exit():
	super.exit()
	
	core.parrying = false
	pass

func physics_update(_delta: float):
	super.physics_update(_delta)
	
	if parryWindowTimer >= parryWindow:
		if inputHandler.blockInput:
			machine.rpc("change_state", "Block")
		else:
			machine.actionExit()
	
	parryWindowTimer += _delta
	pass
