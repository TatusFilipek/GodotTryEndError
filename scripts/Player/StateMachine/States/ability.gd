extends Action
class_name Ability

@onready var hurt_box: Area3D = %BasicAttackHurtBox

var bodies_hit : Array[Node3D]

@export var damage_amount : int = 40

@export var moveVelocity : float = 10 

var applyForce : bool = false

func enter():
	super.enter()
	
	hurt_box.monitoring = false
	applyForce = false
	
	if not core.isWeaponOut: core.isWeaponOut = true
	
	hurt_box.body_entered.connect(on_body_entered)
	pass

func exit():
	#apply endlag if needed before super.exit so it the state doesnt get disabled
	super.exit()
	
	hurt_box.monitoring = false
	applyForce = false
	hurt_box.body_entered.disconnect(on_body_entered)
	pass

func physics_update(_delta: float):
	super.physics_update(_delta)
	
	if hurt_box.monitoring:
		core.velocitySandbox.x = moveVelocity * core.facingDirection
		applyForce = true
		feintable = false
	else:
		core.velocitySandbox.x = 0
		applyForce = false
	
	if playback.get_current_play_position() >= playback.get_current_length(): EndAction()
	pass

func on_body_entered(body: Node3D) -> void:
	if not is_multiplayer_authority(): return
	if bodies_hit.has(body): return
	if body.name == str(get_multiplayer_authority()): return
	
	bodies_hit.append(body)
	
	if body.has_method("TakeDamage"):
		body.rpc("TakeDamage", str(get_multiplayer_authority()), damage_amount)
	pass

func EndAction():
	super.EndAction()
	bodies_hit.clear()
