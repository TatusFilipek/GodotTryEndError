extends Action
class_name WeaponBasicAttack

@onready var hurt_box: Area3D = %BasicAttackHurtBox

var bodies_hit : Array[Node3D]

@export var damage_amount : int

func enter():
	super.enter()
	hurt_box.monitoring = false
	hurt_box.body_entered.connect(on_body_entered)
	pass

func exit():
	super.exit()
	hurt_box.monitoring = false
	hurt_box.body_entered.disconnect(on_body_entered)
	pass

func physics_update(_delta: float):
	super.physics_update(_delta)
	
	if playback.get_current_play_position() >= playback.get_current_length(): EndAction()

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
