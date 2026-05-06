extends Camera2D

@export var followed : Node2D

#TODO:
	#set camera limits via code
	#make camera show more of whats in front of u

func _ready() -> void:
	followed = get_parent().get_node("player")

func _physics_process(delta: float) -> void:
	position = followed.global_position
