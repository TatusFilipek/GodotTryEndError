extends Action
class_name WeaponBasicAttack

@onready var hurt_box: Area3D = %BasicAttackHurtBox

var bodies_hit : Array[Node3D]

@export var damage_amount : int = 20

@export var max_combo : int = 3
@export var current_combo : int = 0

func enter():
	super.attackEnter()
	
	if core.attackComboTimer < 0: current_combo = 0
	
	current_combo+=1
	if current_combo > max_combo: current_combo = 1
	
	playback.travel(animationName+str(current_combo))
	
	hurt_box.monitoring = false
	hurt_box.body_entered.connect(on_body_entered)

func exit():
	super.exit()
	
	hurt_box.monitoring = false
	
	core.attackComboTimer = core.attackComboTime
	
	hurt_box.body_entered.disconnect(on_body_entered)

func physics_update(_delta: float):
	super.physics_update(_delta)
	
	if playback.get_current_play_position() >= playback.get_current_length(): EndAction()

func on_body_entered(body: Node3D) -> void:
	if not is_multiplayer_authority(): return
	if bodies_hit.has(body): return
	if body.name == str(get_multiplayer_authority()): return
	
	bodies_hit.append(body)
	
	if body.has_method("TakeDamage"):
		if current_combo == max_combo:
			body.rpc("TakeDamage", str(get_multiplayer_authority()), damage_amount*1.4)
		else:
			body.rpc("TakeDamage", str(get_multiplayer_authority()), damage_amount)
	pass

func EndAction():
	super.EndAction()
	bodies_hit.clear()
