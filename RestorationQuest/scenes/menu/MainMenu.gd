extends Control

# Main menu scene controller
# Displays title, level select, settings, and credits

var selected_level = 1
var show_settings = false

func _ready():
	# Wait a frame to ensure all nodes are loaded
	await get_tree().process_frame
	
	# Set labels
	if has_node("VBoxContainer/TitleLabel"):
		$VBoxContainer/TitleLabel.text = "RESTORATION QUEST"
	if has_node("VBoxContainer/SubtitleLabel"):
		$VBoxContainer/SubtitleLabel.text = "A Journey Through Sacred History"
	
	# Connect button signals with proper error checking
	_connect_button("VBoxContainer/PlayButton", _on_play_pressed)
	_connect_button("VBoxContainer/LevelSelectButton", _on_level_select_pressed)
	_connect_button("VBoxContainer/SettingsButton", _on_settings_pressed)
	_connect_button("VBoxContainer/CreditsButton", _on_credits_pressed)
	_connect_button("VBoxContainer/QuitButton", _on_quit_pressed)
	
	update_level_buttons()

func _connect_button(path: String, callback: Callable) -> void:
	var button = get_node_or_null(path)
	if button and button is Button:
		button.pressed.connect(callback)
	else:
		push_error("Button not found: " + path)

func _input(event: InputEvent) -> void:
	if show_settings and event.is_action_pressed("ui_cancel"):
		show_settings = false
		$SettingsPanel.hide()
		get_tree().root.set_input_as_handled()
		return
	
	if not show_settings:
		if event is InputEventKey:
			if event.pressed:
				match event.keycode:
					KEY_1: _select_level(1)
					KEY_2: _select_level(2)
					KEY_3: _select_level(3)
					KEY_4: _select_level(4)
					KEY_5: _select_level(5)
					KEY_6: _select_level(6)
					KEY_7: _select_level(7)

func _select_level(level: int) -> void:
	selected_level = level
	get_tree().change_scene_to_file("res://scenes/levels/Level%d.tscn" % level)

func _on_play_pressed() -> void:
	_select_level(1)

func _on_level_select_pressed() -> void:
	var menu = Control.new()
	menu.name = "LevelSelectMenu"
	var bg = ColorRect.new()
	bg.color = Color.BLACK
	bg.color.a = 0.7
	bg.anchor_left = 0
	bg.anchor_top = 0
	bg.anchor_right = 1
	bg.anchor_bottom = 1
	menu.add_child(bg)
	
	var vbox = VBoxContainer.new()
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -150
	vbox.offset_top = -200
	vbox.offset_right = 150
	vbox.offset_bottom = 200
	
	var title = Label.new()
	title.text = "SELECT LEVEL"
	title.add_theme_font_size_override("font_size", 40)
	title.alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Create grid of level buttons
	var grid = GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	
	for i in range(1, 8):
		var btn = Button.new()
		btn.text = "Level %d" % i
		btn.add_theme_font_size_override("font_size", 20)
		btn.custom_minimum_size = Vector2(90, 60)
		btn.pressed.connect(_select_level.bindv([i]))
		grid.add_child(btn)
	
	vbox.add_child(grid)
	
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 20
	vbox.add_child(spacer)
	
	var back_btn = Button.new()
	back_btn.text = "Back"
	back_btn.add_theme_font_size_override("font_size", 20)
	back_btn.pressed.connect(func(): menu.queue_free())
	vbox.add_child(back_btn)
	
	menu.add_child(vbox)
	add_child(menu)

func _on_settings_pressed() -> void:
	var panel = Control.new()
	panel.name = "SettingsMenu"
	var bg = ColorRect.new()
	bg.color = Color.BLACK
	bg.color.a = 0.7
	bg.anchor_left = 0
	bg.anchor_top = 0
	bg.anchor_right = 1
	bg.anchor_bottom = 1
	panel.add_child(bg)
	
	var vbox = VBoxContainer.new()
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -150
	vbox.offset_top = -150
	vbox.offset_right = 150
	vbox.offset_bottom = 150
	
	var title = Label.new()
	title.text = "SETTINGS"
	title.add_theme_font_size_override("font_size", 40)
	title.alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	var note = Label.new()
	note.text = "More options coming soon!"
	note.add_theme_font_size_override("font_size", 18)
	note.alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(note)
	
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 40
	vbox.add_child(spacer)
	
	var back_btn = Button.new()
	back_btn.text = "Back"
	back_btn.add_theme_font_size_override("font_size", 20)
	back_btn.pressed.connect(func(): panel.queue_free())
	vbox.add_child(back_btn)
	
	panel.add_child(vbox)
	add_child(panel)

func _on_credits_pressed() -> void:
	var panel = Control.new()
	panel.name = "CreditsMenu"
	var bg = ColorRect.new()
	bg.color = Color.BLACK
	bg.color.a = 0.7
	bg.anchor_left = 0
	bg.anchor_top = 0
	bg.anchor_right = 1
	bg.anchor_bottom = 1
	panel.add_child(bg)
	
	var vbox = VBoxContainer.new()
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -150
	vbox.offset_top = -200
	vbox.offset_right = 150
	vbox.offset_bottom = 200
	
	var title = Label.new()
	title.text = "CREDITS"
	title.add_theme_font_size_override("font_size", 40)
	title.alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	var credits_text = Label.new()
	credits_text.text = """Game Design & Development
divisCorp

Inspired by the Legacy of
Joseph Smith and the Restoration
"""
	credits_text.add_theme_font_size_override("font_size", 16)
	credits_text.alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(credits_text)
	
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 40
	vbox.add_child(spacer)
	
	var back_btn = Button.new()
	back_btn.text = "Back"
	back_btn.add_theme_font_size_override("font_size", 20)
	back_btn.pressed.connect(func(): panel.queue_free())
	vbox.add_child(back_btn)
	
	panel.add_child(vbox)
	add_child(panel)

func _on_quit_pressed() -> void:
	get_tree().quit()

func update_level_buttons() -> void:
	# Enable/disable level buttons based on progression
	# For now, all 7 are available
	for i in range(1, 8):
		var btn = get_node_or_null("VBoxContainer/LevelGrid/Level%dButton" % i)
		if btn:
			btn.disabled = false
