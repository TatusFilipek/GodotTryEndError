extends Node3D
class_name CameraOrigin

@onready var player: Player = $".."
@onready var camera: Camera3D = %Camera
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D

@export var cameraSensitivity : float = 0.05

@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle : float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vertical_angle : float = PI/4

@export var shift_lock : bool = false
@export var shiftLockCameraOffset : Vector3 = Vector3(0.7, 0.2, 0)
var defaultCameraPosition : Vector3

func _ready() -> void:
	defaultCameraPosition = camera.position
	
	if is_multiplayer_authority():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion and (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or Input.is_action_pressed("look")):
		rotation.y -= event.relative.x * cameraSensitivity / 10
		rotation.y = wrapf(rotation.y, 0, TAU)
		
		rotation.x -= event.relative.y * cameraSensitivity / 10
		rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
	
	if event.is_action_pressed("camera_in"):
		spring_arm_3d.spring_length -= 1
	if event.is_action_pressed("camera_out"):
		spring_arm_3d.spring_length += 1
	
	if event.is_action_pressed("shiftLock"):
		shift_lock = !shift_lock
		
		if shift_lock:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	var targetCamPos := defaultCameraPosition
	
	if shift_lock: targetCamPos += shiftLockCameraOffset
	
	camera.position = camera.position.lerp(targetCamPos, 12 * delta)
