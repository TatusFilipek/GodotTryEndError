extends State
class_name GroundState

func enter() -> void:
	super.enter()
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if not core.is_on_floor():
		machine.change_state("FallIdle")
		return
		
	if Input.is_action_just_pressed("moveUp"):
		machine.change_state("Jump")
		return

	pass
