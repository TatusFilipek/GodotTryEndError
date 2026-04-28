extends State
class_name AirState

func enter() -> void:
	super.enter()
	pass

func exit() -> void:
	super.exit()
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	
	if core.is_on_floor():
		machine.change_state("Idle")
		return
		
	core.velocity.y += core.CalcGravity() * _delta; # Gravity
	
	if playback:
		if core.velocity.y < -core.jumpApex:
			playback.travel("InAirUp")
		elif core.velocity.y > core.jumpApex:
			playback.travel("InAirDown")
		else:
			if core.velocity.y >= 0:
				playback.travel("InAirDownApex")
			else:
				playback.travel("InAirUpApex")
	pass
