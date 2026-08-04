extends Node3D

@onready var player: Player = $".."

@export var cameraSensitivity : float = 0.05

@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle : float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vertical_angle : float = PI/4

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and (player.isShiftLock or Input.is_action_pressed("look")):
		rotation.y -= event.relative.x * cameraSensitivity / 10
		rotation.y = wrapf(rotation.y, 0, TAU)
		
		rotation.x -= event.relative.y * cameraSensitivity / 10
		rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
