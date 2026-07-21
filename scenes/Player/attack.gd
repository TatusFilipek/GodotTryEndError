extends Node3D
class_name Attack

@onready var area_3d: Area3D = %Area3D

var bodies_hit : Array[Node3D]

@export var damage_amount : int

@export var weaponOutPosition : Vector3
@export var weaponPosition : Vector3
@export var weaponOutRotation : Vector3
@export var weaponRotation : Vector3

signal attackFinished()

func _ready() -> void:
	area_3d.monitoring = false
	area_3d.body_entered.connect(on_body_entered)
	attackFinished.connect(func(): bodies_hit.clear())

func on_body_entered(body: Node3D) -> void:
	if not is_multiplayer_authority(): return
	if bodies_hit.has(body): return
	if body.name == str(get_multiplayer_authority()): return
	
	bodies_hit.append(body)
	
	if body.has_method("TakeDamage"):
		body.rpc("TakeDamage", str(get_multiplayer_authority()), damage_amount)
	pass
