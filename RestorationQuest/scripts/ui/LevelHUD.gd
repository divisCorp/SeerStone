extends CanvasLayer

@onready var timer_label: Label = Label.new()
@onready var health_label: Label = Label.new()

var level_time: float = 0.0
var player: Node2D = null

func _ready():
	layer = 50
	
	# Timer label (top center)
	timer_label.text = "TIME: 0:00"
	timer_label.add_theme_font_size_override("font_size", 24)
	timer_label.anchor_left = 0.5
	timer_label.anchor_top = 0.0
	timer_label.offset_left = -60
	timer_label.offset_top = 10
	timer_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(timer_label)
	
	# Health label (top left)
	health_label.text = "HEALTH: 100"
	health_label.add_theme_font_size_override("font_size", 20)
	health_label.anchor_left = 0.0
	health_label.anchor_top = 0.0
	health_label.offset_left = 10
	health_label.offset_top = 10
	health_label.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2, 1.0))  # Green
	add_child(health_label)
	
	# Find player
	var root = get_tree().current_scene
	if root and root.has_node("Player"):
		player = root.get_node("Player")

func _process(delta: float) -> void:
	level_time += delta
	
	# Update timer display (MM:SS)
	var minutes = int(level_time) / 60
	var seconds = int(level_time) % 60
	timer_label.text = "TIME: %d:%02d" % [minutes, seconds]
	
	# Update health display
	if player and player.has_meta("health"):
		var hp = player.get_meta("health")
		health_label.text = "HEALTH: %d" % hp
		# Color shift red if low health
		if hp < 30:
			health_label.add_theme_color_override("font_color", Color(0.9, 0.1, 0.1, 1.0))
		else:
			health_label.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2, 1.0))
