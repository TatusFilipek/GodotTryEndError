extends State
class_name LedgeClimb

#TODO: Fix this shit asap
#fixxed somehow but still its not optimised, i could save the last ledge pos to a variable so i dont have to use the same function twice
#fixxed everything including animation
#NOTE: can still tinker with the offsets, they arent perfect, they could be better

var postAnimPos : Vector3

func enter() -> void:
	super.enter()
	
	playback.travel("LedgeClimb")
	core.velocitySandbox = Vector3.ZERO
	core.canChangeDir = false
	
	#NOTE: tmp animation offset
	core.VisualsNode.position.x = -.25 * core.facingDirection
	core.VisualsNode.position.y = .035
	
	postAnimPos = core.ledgePosition
	
	postAnimPos.x += core.check_wall_top.position.x + .175 * core.facingDirection
	#postAnimPos.y += core.check_ledge.position.y
	#postAnimPos.y += .01
	pass

func exit() -> void:
	super.exit()
	core.canChangeDir = true
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	pass

func AnimationFinished() -> void:
	#NOTE: tmp animation offset
	core.VisualsNode.position.x = 0
	core.VisualsNode.position.y = 0
	
	core.position = postAnimPos
	machine.actionExit()
