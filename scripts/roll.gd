extends State
class_name Roll

#NOTE:
	#wiem co sie dzieje animacja ustawia sie na dobra klatke ale w tym samym czasie animacja odpala sie od poczatku co powoduje ze skacze co jakis czas pomiedzy klatkami puki sie nie zakaczy
	#AI mi to rozwiazalo ale szczerze to jest taki slop

func enter() -> void:
	super.enter()
	
	core.resizeCollider(0.7)
	
	core.canChangeDir = false
	core.rolling = true
	pass

func exit() -> void:
	super.exit()
	
	core.canChangeDir = true
	core.rolling = false
	animationTree.active = true
	pass

func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if not isActive: return
	
	if abs(core.velocity.x) > core.rollVelocityTreshold: 
		core.velocity.x -= core.rollVelocityLoss * core.facingDirection * _delta
	else:
		core.velocity.x = 0
	pass

func StartAnim(_time : float, _animName : String) -> void:
	animationTree.active = false
	
	animationPlayer.play(_animName)
	animationPlayer.seek(_time, true)

func AnimationFinished() -> void:
	core.rollAnimFrame = 0
	animationPlayer.pause()
	machine.actionExit()
