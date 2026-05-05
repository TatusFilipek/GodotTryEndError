extends State
class_name LedgeGrab

var ledgePos : Vector2

func enter() -> void:
	super.enter()
	
	playback.travel("LedgeGrab")
	core.velocity = Vector2.ZERO
	
	ledgePos = core.GetLedgePosition()
	core.global_position = core.SetLedgeOffset(ledgePos)
	
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if Input.is_action_pressed("moveDown"):
		machine.change_state("FallIdle")
		return
	
	if not core.IsLedgeDetected():
		machine.change_state("FallIdle")
		return
	
	#if sign(core.MovementDirection()) == sign(core.CheckWall.target_position.x) and Input.is_action_pressed("moveUp"):
	if Input.is_action_pressed("moveUp") and core.IsSpaceToClimb():
		machine.change_state("LedgeClimb")
		return
	
	#if there is space to fit a player and up and a certain direcion is pressed then go to ledge climb, if there isnt space or only up is pressed preform jump
	if core.jumpInputBufferTimer > 0:
		core.jumpInputBufferTimer = 0
		machine.change_state("Jump")
		return
	pass
