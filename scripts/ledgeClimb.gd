extends State
class_name LedgeClimb

#TODO: Fix this shit asap
#fixxed somehow but still its not optimised, i could save the last ledge pos to a variable so i dont have to use the same function twice

var ledgePos : Vector2
var postAnimPos : Vector2

func enter() -> void:
	super.enter()
	
	playback.travel("LedgeClimb")
	core.velocity = Vector2.ZERO
	
	postAnimPos = core.GetLedgePosition()
	
	postAnimPos.x += core.CheckWall.position.x + 17 * core.facingDirection
	postAnimPos.y += core.CheckLedge.position.y
		
	#core.position = postAnimPos
	
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	pass

func AnimationFinished() -> void:
	core.position = postAnimPos
	machine.change_state("Idle")
