extends Control

@onready var buttons: VBoxContainer = $Buttons
@onready var game_name: Label = $GameName
@onready var margins: MarginContainer = $Margins
@onready var credits: HBoxContainer = $Margins/Credits
@onready var options: HBoxContainer = $Margins/Options

func _ready() -> void:
	margins.visible = false
	credits.visible = false
	options.visible = false
	buttons.visible = true
	game_name.visible = true

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rework3d.tscn")

func _on_options_pressed() -> void:
	margins.visible = true
	credits.visible = false
	options.visible = true
	buttons.visible = false
	game_name.visible = false

func _on_credits_pressed() -> void:
	margins.visible = true
	credits.visible = true
	options.visible = false
	buttons.visible = false
	game_name.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	margins.visible = false
	buttons.visible = true
	game_name.visible = true
