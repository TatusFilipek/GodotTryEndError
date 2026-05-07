extends Roll
class_name RollInAir


func enter() -> void:
	super.enter()
	
	#NOTE:
	#wiem co sie dzieje animacja ustawia sie na dobra klatke ale w tym samym czasie animacja odpala sie od poczatku co powoduje ze skacze co jakis czas pomiedzy klatkami puki sie nie zakaczy
	#AI mi to rozwiazalo ale szczerze to jest taki slop
	
	StartAnim(float(core.rollAnimFrame) / 8, "RollInAir")
	pass

func exit() -> void:
	super.exit()
	animationTree.active = true
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	core.velocity.y += core.CalcGravity() * _delta; # Gravity
	
	#TODO: fix later	
	if core.isOnGround():
		core.rollAnimFrame = animation.frame
		
		machine.change_state("RollGround")
		return

func AnimationFinished() -> void:
	core.rollAnimFrame = 0
	animationPlayer.stop()
	machine.change_state("FallIdle")
