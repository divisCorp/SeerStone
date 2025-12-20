extends Control

# Level Complete screen
# Shown when player defeats the boss and completes the level

var current_level: int = 1
var next_level: int = 2

signal next_level_pressed
signal menu_pressed

func _ready():
	hide()
	await get_tree().process_frame
	_connect_button("VBoxContainer/NextButton", _on_next_pressed)
	_connect_button("VBoxContainer/MenuButton", _on_menu_pressed)

func _connect_button(path: String, callback: Callable) -> void:
	var button = get_node_or_null(path)
	if button and button is Button:
		button.pressed.connect(callback)
	else:
		push_error("LevelComplete button not found: " + path)

func show_level_complete(level: int) -> void:
	current_level = level
	next_level = level + 1 if level < 7 else 1
	
	$VBoxContainer/TitleLabel.text = "LEVEL %d COMPLETE!" % level
	if level == 7:
		$VBoxContainer/SubtitleLabel.text = "You've restored the Kingdom!"
		$VBoxContainer/NextButton.text = "Play Again"
	else:
		$VBoxContainer/SubtitleLabel.text = "Next: Level %d" % next_level
		$VBoxContainer/NextButton.text = "Continue"
	
	show()
	get_tree().paused = true

func _on_next_pressed() -> void:
	get_tree().paused = false
	if current_level == 7:
		get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/levels/Level%d.tscn" % next_level)

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
