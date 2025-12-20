extends Control

# Pause menu overlay
# Shown when player presses ESC during gameplay

signal resume_pressed
signal settings_pressed
signal quit_to_menu_pressed

func _ready():
	hide()
	await get_tree().process_frame
	_connect_button("VBoxContainer/ResumeButton", _on_resume_pressed)
	_connect_button("VBoxContainer/SettingsButton", _on_settings_pressed)
	_connect_button("VBoxContainer/QuitButton", _on_quit_pressed)

func _connect_button(path: String, callback: Callable) -> void:
	var button = get_node_or_null(path)
	if button and button is Button:
		button.pressed.connect(callback)
	else:
		push_error("PauseMenu button not found: " + path)

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		_on_resume_pressed()
		get_tree().root.set_input_as_handled()

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false
	resume_pressed.emit()

func _on_settings_pressed() -> void:
	settings_pressed.emit()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	quit_to_menu_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")

func show_pause_menu() -> void:
	show()
	get_tree().paused = true
