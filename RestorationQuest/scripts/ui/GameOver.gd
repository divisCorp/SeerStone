extends Control

# Game Over screen
# Shown when player's faith depletes and they die

var current_level: int = 1

signal retry_pressed
signal menu_pressed

func _ready():
	hide()
	await get_tree().process_frame
	_connect_button("VBoxContainer/RetryButton", _on_retry_pressed)
	_connect_button("VBoxContainer/MenuButton", _on_menu_pressed)

func _connect_button(path: String, callback: Callable) -> void:
	var button = get_node_or_null(path)
	if button and button is Button:
		button.pressed.connect(callback)
	else:
		push_error("GameOver button not found: " + path)

func show_game_over(level: int) -> void:
	current_level = level
	$VBoxContainer/TitleLabel.text = "FAITH DEPLETED"
	$VBoxContainer/SubtitleLabel.text = "Level %d - Try Again" % level
	show()
	get_tree().paused = true

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
