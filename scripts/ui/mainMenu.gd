extends CanvasLayer

@onready var buttons: VBoxContainer = $Control/Buttons
@onready var game_name: Label = $Control/GameName
@onready var margins: MarginContainer = $Control/Margins
@onready var credits: HBoxContainer = $Control/Margins/Credits
@onready var options: HBoxContainer = $Control/Margins/Options

@onready var startBTN: Button = %Start
@onready var optionsBTN: Button = %Options
@onready var creditsBTN: Button = %Credits
@onready var exitBTN: Button = %Exit

const WORLD = preload("uid://boqducct2smkj")
const PLAYER = preload("uid://b5uy0wyxkan33")

func _ready() -> void:
	margins.visible = false
	credits.visible = false
	options.visible = false
	buttons.visible = true
	game_name.visible = true
	
	startBTN.pressed.connect(on_start_pressed)
	optionsBTN.pressed.connect(on_options_pressed)
	creditsBTN.pressed.connect(on_credits_pressed)
	exitBTN.pressed.connect(on_exit_pressed)
	
	if OS.has_feature("server"):
		Network.start_server()
		add_world()
		hide()

func on_start_pressed() -> void:
	Network.join_server()
	add_world()
	hide()

func on_options_pressed() -> void:
	margins.visible = true
	credits.visible = false
	options.visible = true
	buttons.visible = false
	game_name.visible = false

func on_credits_pressed() -> void:
	margins.visible = true
	credits.visible = true
	options.visible = false
	buttons.visible = false
	game_name.visible = false

func on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	margins.visible = false
	buttons.visible = true
	game_name.visible = true

func add_world() -> void:
	var new_world = WORLD.instantiate()
	get_tree().current_scene.add_child.call_deferred(new_world)
