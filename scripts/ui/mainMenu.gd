extends CanvasLayer

@onready var buttons: VBoxContainer = $Control/Buttons
@onready var game_name: Label = $Control/GameName
@onready var margins: MarginContainer = $Control/Margins
@onready var credits: HBoxContainer = $Control/Margins/Credits
@onready var options: HBoxContainer = $Control/Margins/Options
@onready var start_menu: HBoxContainer = $Control/Margins/StartMenu

@onready var startBTN: Button = %Start
@onready var optionsBTN: Button = %Options
@onready var creditsBTN: Button = %Credits
@onready var exitBTN: Button = %Exit

@onready var e_net: Button = %ENet
@onready var tube: Button = %Tube

@onready var name_tag: LineEdit = %NameTag
@onready var session_id: LineEdit = %SessionId
@onready var create_session: Button = %CreateSession

const WORLD = preload("uid://boqducct2smkj")
const PLAYER = preload("uid://b5uy0wyxkan33")

func _ready() -> void:
	if Network.tube_enabled: e_net.hide()
	else: tube.hide()
	
	margins.visible = false
	credits.visible = false
	options.visible = false
	start_menu.visible = false
	buttons.visible = true
	game_name.visible = true
	
	tube.disabled = true
	
	session_id.text_changed.connect(update_session)
	name_tag.text_changed.connect(update_name_tag)
	
	startBTN.pressed.connect(on_start_pressed)
	optionsBTN.pressed.connect(on_options_pressed)
	creditsBTN.pressed.connect(on_credits_pressed)
	exitBTN.pressed.connect(on_exit_pressed)
	e_net.pressed.connect(on_e_net_pressed)
	tube.pressed.connect(on_tube_pressed)
	create_session.pressed.connect(on_create_session_pressed)
	
	Network.tube_client.error_raised.connect(on_error_raised)
	
	if OS.has_feature("server"):
		Network.start_server()
		await get_tree().create_timer(.1).timeout
		add_world()

func update_session(new_text: String) -> void:
	if new_text != "": tube.disabled = false

func update_name_tag(new_text: String) -> void:
	pass

func on_create_session_pressed() -> void:
	Network.tube_create()
	add_world()

func on_e_net_pressed() -> void:
	Network.join_server()
	add_world()

func on_tube_pressed() -> void:
	Network.tube_join(session_id.text)
	multiplayer.connected_to_server.connect(add_world)

func on_error_raised(_core, _message) -> void:
	session_id.text = ""
	tube.disabled = true
	Network.clean_up_signals()

func on_start_pressed() -> void:
	margins.visible = true
	credits.visible = false
	options.visible = false
	start_menu.visible = true
	buttons.visible = false
	game_name.visible = false

func on_options_pressed() -> void:
	margins.visible = true
	credits.visible = false
	options.visible = true
	start_menu.visible = false
	buttons.visible = false
	game_name.visible = false

func on_credits_pressed() -> void:
	margins.visible = true
	credits.visible = true
	options.visible = false
	start_menu.visible = false
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
	get_tree().current_scene.add_child(new_world)
	hide()
