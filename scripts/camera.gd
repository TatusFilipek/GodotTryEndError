extends Camera3D

@export var followed : Node3D
@export var camera_z_offset : float = 15.0
@export var smooth_speed : float = 5.0

func _ready() -> void:
	# Make sure your character instance node name inside the main scene matches
	followed = get_parent().get_node("Player3D")

func _physics_process(delta: float) -> void:
	if not followed: return
	
	# Compute a target location preserving structural platform depth tracking coordinates
	var target_position = Vector3(followed.global_position.x, followed.global_position.y, camera_z_offset)
	
	# Smooth linear interpolation transition tracking
	global_position = global_position.lerp(target_position, smooth_speed * delta)
	#global_position = target_position
	
	# Explicitly direct lens angle horizontally right onto character tracking plane
	look_at(Vector3(global_position.x, global_position.y, 0.0))
