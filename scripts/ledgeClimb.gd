extends State
class_name LedgeClimb

#TODO: Fix this shit asap

var ledgePos : Vector2
var postAnimPos : Vector2
var rayPosition : Vector2

func enter() -> void:
	super.enter()
	
	playback.travel("LedgeClimb")
	core.velocity = Vector2.ZERO
	
	#postAnimPos = core.position
	#postAnimPos.x += core.CheckWall.position.x + 17 * core.facingDirection
	#postAnimPos.y += core.CheckLedge.position.y
	
		
	rayPosition = core.position
		
	rayPosition.x += core.CheckWall.position.x + 17 * core.facingDirection
	rayPosition.y += core.CheckLedge.position.y
	
	#core.position = rayPosition
	
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	#if animation complete snap player to rayposition and change state to idle
	core.position = rayPosition
	
	machine.change_state("Idle")
	return
	pass
