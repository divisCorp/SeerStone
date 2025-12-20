extends Node2D

@export var level_id: int = 1

const PLAYER_SCENE = preload("res://scenes/player/player.tscn")
const VINE_SCRIPT = preload("res://scripts/mechanics/vine_swing.gd")
const FLOAT_SCRIPT = preload("res://scripts/mechanics/floating_platform.gd")
const DIG_SCRIPT = preload("res://scripts/mechanics/dig_zone.gd")
const PRESS_SCRIPT = preload("res://scripts/mechanics/press_puzzle.gd")
const SWIM_SCRIPT = preload("res://scripts/mechanics/swim_zone.gd")
const TEMPLE_SCRIPT = preload("res://scripts/mechanics/temple_climb.gd")
const WAGON_SCRIPT = preload("res://scripts/mechanics/wagon_platform.gd")
const BOSS_SCENES = {
	1: preload("res://scenes/enemies/Boss1.tscn"),
	2: preload("res://scenes/enemies/Boss2.tscn"),
	3: preload("res://scenes/enemies/Boss3.tscn"),
	4: preload("res://scenes/enemies/Boss4.tscn"),
	5: preload("res://scenes/enemies/Boss5.tscn"),
	6: preload("res://scenes/enemies/Boss6.tscn"),
	7: preload("res://scenes/enemies/Boss7.tscn"),
}

# Level geometry constants
const LEVEL_WIDTH := 3000
const GROUND_Y := 550
func _ready():
	_setup_world()
	_spawn_ui_overlays()
	_spawn_level_hud()
	_spawn_level_hud_timer()
	_spawn_player()
	_create_ground()
	match level_id:
		1:
			_setup_first_vision()
		2:
			_setup_moroni()
		3:
			_setup_hill_cumorah()
		4:
			_setup_printers_press()
		5:
			_setup_fayette()
		6:
			_setup_kirtland()
		7:
			_setup_nauvoo()
	_spawn_boss_if_any()

func _setup_world():
	# Create a background CanvasLayer that won't be affected by camera zoom
	var bg_canvas = CanvasLayer.new()
	bg_canvas.layer = -1
	add_child(bg_canvas)
	
	# Mario-style gradient sky background
	var bg = ColorRect.new()
	bg.anchor_left = 0.0
	bg.anchor_top = 0.0
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.color = Color(0.4, 0.7, 1.0, 1.0)  # Sky blue
	bg_canvas.add_child(bg)
	
	# Background clouds/mountains disabled for clean slate
	# _add_background_clouds(bg_canvas)
	
	print("Background set with clouds")

func _add_background_clouds(bg_canvas: CanvasLayer) -> void:
	# Add pixel art mountains in background
	var mountains = [
		{"x": 100, "height": 250, "width": 300, "color": Color(0.3, 0.5, 0.3)},
		{"x": 350, "height": 200, "width": 250, "color": Color(0.35, 0.55, 0.35)},
		{"x": 550, "height": 280, "width": 350, "color": Color(0.28, 0.48, 0.28)},
		{"x": 850, "height": 220, "width": 280, "color": Color(0.32, 0.52, 0.32)},
		{"x": 1100, "height": 260, "width": 320, "color": Color(0.3, 0.5, 0.3)},
	]
	
	for mountain in mountains:
		# Create triangle mountain shape
		var peak_x = mountain.x + mountain.width / 2
		var base_y = 400
		
		# Draw mountain as stacked rectangles for pixel art effect
		for i in range(mountain.height / 10):
			var segment_width = mountain.width * (1.0 - float(i) / (mountain.height / 10))
			var rect = ColorRect.new()
			rect.size = Vector2(segment_width, 10)
			rect.position = Vector2(peak_x - segment_width / 2, base_y - i * 10)
			rect.color = mountain.color
			rect.modulate.a = 0.6
			bg_canvas.add_child(rect)
	
	# Add some clouds
	var cloud_positions = [
		Vector2(200, 80),
		Vector2(600, 120),
		Vector2(1000, 60),
	]
	
	for pos in cloud_positions:
		var cloud = ColorRect.new()
		cloud.size = Vector2(120, 40)
		cloud.position = pos
		cloud.color = Color.WHITE
		cloud.modulate.a = 0.7
		bg_canvas.add_child(cloud)

func _spawn_ui_overlays():
	# Create UI overlay canvas for menus
	var ui_canvas = CanvasLayer.new()
	ui_canvas.layer = 100
	ui_canvas.name = "UILayer"
	add_child(ui_canvas)
	
	# Pause Menu
	var pause_script = load("res://scripts/ui/PauseMenu.gd")
	if pause_script:
		var pause_menu = Control.new()
		pause_menu.script = pause_script
		pause_menu.anchor_left = 0.0
		pause_menu.anchor_top = 0.0
		pause_menu.anchor_right = 1.0
		pause_menu.anchor_bottom = 1.0
		ui_canvas.add_child(pause_menu)
	
	# Level Complete Screen
	var complete_script = load("res://scripts/ui/LevelComplete.gd")
	if complete_script:
		var complete = Control.new()
		complete.script = complete_script
		complete.anchor_left = 0.0
		complete.anchor_top = 0.0
		complete.anchor_right = 1.0
		complete.anchor_bottom = 1.0
		ui_canvas.add_child(complete)
	
	# Game Over Screen
	var gameover_script = load("res://scripts/ui/GameOver.gd")
	if gameover_script:
		var gameover = Control.new()
		gameover.script = gameover_script
		gameover.anchor_left = 0.0
		gameover.anchor_top = 0.0
		gameover.anchor_right = 1.0
		gameover.anchor_bottom = 1.0
		ui_canvas.add_child(gameover)

func _spawn_level_hud():
	# Create HUD canvas layer
	var hud_canvas = CanvasLayer.new()
	hud_canvas.layer = 50
	hud_canvas.name = "HUDLayer"
	add_child(hud_canvas)

func _spawn_level_hud_timer():
	# Create HUD canvas layer for timer and health
	var hud_canvas = CanvasLayer.new()
	hud_canvas.layer = 50
	hud_canvas.name = "LevelHUD"
	add_child(hud_canvas)
	
	# Load and add the timer/health HUD script
	var hud_script = load("res://scripts/ui/LevelHUD.gd")
	if hud_script:
		var hud = CanvasLayer.new()
		hud.script = hud_script
		hud.name = "TimerHealth"
		add_child(hud)
	
	# Level title
	var title = Label.new()
	title.text = "LEVEL %d" % level_id
	title.add_theme_font_size_override("font_size", 32)
	title.anchor_left = 0.5
	title.anchor_top = 0.0
	title.offset_left = -60
	title.offset_top = 20
	title.add_theme_color_override("font_color", Color.WHITE)
	hud_canvas.add_child(title)
	
	# Level name based on level_id
	var level_names = {
		1: "SACRED GROVE",
		2: "MORONI'S VISITS",
		3: "HILL CUMORAH",
		4: "PRINTER'S PRESS",
		5: "FAYETTE",
		6: "KIRTLAND TEMPLE",
		7: "NAUVOO"
	}
	
	var subtitle = Label.new()
	subtitle.text = level_names.get(level_id, "RESTORATION QUEST")
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.anchor_left = 0.5
	subtitle.anchor_top = 0.0
	subtitle.offset_left = -80
	subtitle.offset_top = 55
	subtitle.add_theme_color_override("font_color", Color(0.9, 0.9, 0.1, 1.0))
	hud_canvas.add_child(subtitle)

func _spawn_player():
	# Check if player already exists
	var existing_players = get_tree().get_nodes_in_group("player")
	if existing_players.size() > 0:
		print("Player already spawned, skipping")
		return
	
	var player = PLAYER_SCENE.instantiate()
	player.position = Vector2(100, 520)
	add_child(player)
	player.add_to_group("player")
	var cam = Camera2D.new()
	cam.zoom = Vector2(1.6, 1.6)
	cam.limit_left = 0
	cam.limit_right = LEVEL_WIDTH
	cam.limit_top = 0
	cam.limit_bottom = 700
	player.add_child(cam)
	# Call make_current() after adding to tree
	cam.make_current()

func _create_ground():
	var ground = StaticBody2D.new()
	ground.name = "Ground"

	# Define pit locations
	var pit_ranges = [
		{"start": 400, "end": 500},
		{"start": 900, "end": 1000},
		{"start": 1500, "end": 1650},
	]
	
	# Create collision segments with gaps for pits
	var segments = [
		{"start": 0, "end": 400},
		{"start": 500, "end": 900},
		{"start": 1000, "end": 1500},
		{"start": 1650, "end": LEVEL_WIDTH},
	]
	
	for segment in segments:
		var cs = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		var segment_width = segment.end - segment.start
		rect.size = Vector2(segment_width, 32)
		cs.shape = rect
		cs.position = Vector2(segment.start + segment_width / 2, 16)
		ground.add_child(cs)

	# Pixel art tiled ground with depth - extends to bottom of screen
	# Create pits by skipping certain tile ranges (defined above)
	
	var tile_size = 32
	var tile_height = 200  # Extended height to fill screen bottom
	var num_tiles = int(LEVEL_WIDTH / tile_size)

	for i in range(num_tiles):
		var tile_x = i * tile_size
		
		# Skip tiles in pit ranges
		var in_pit = false
		for pit in pit_ranges:
			if tile_x >= pit.start and tile_x < pit.end:
				in_pit = true
				break
		if in_pit:
			continue
		
		var tile = ColorRect.new()
		tile.size = Vector2(tile_size, tile_height)
		tile.position = Vector2(tile_x, 0)
		# Grass green with slight variation
		var variation = (i % 3) * 0.05
		tile.color = Color(0.2 + variation, 0.6 + variation, 0.2 + variation, 1.0)

		# Add grass detail on top
		var grass = ColorRect.new()
		grass.size = Vector2(tile_size, 3)
		grass.position = Vector2(0, 0)
		grass.color = Color(0.3, 0.7, 0.3, 1.0)
		tile.add_child(grass)
		
		# Add dirt layer below
		var dirt = ColorRect.new()
		dirt.size = Vector2(tile_size, tile_size - 8)
		dirt.position = Vector2(0, 8)
		dirt.color = Color(0.4, 0.3, 0.2, 1.0)
		tile.add_child(dirt)

		ground.add_child(tile)

	# Place ground so that its local y=0 aligns with the visual ground Y
	ground.position = Vector2(0, GROUND_Y)
	add_child(ground)

	# Add invisible level bounds so player can't fall off edges
	_add_level_bounds()

func _add_level_bounds() -> void:
	# Left wall
	var left_wall = StaticBody2D.new()
	left_wall.name = "LeftBound"
	var left_cs = CollisionShape2D.new()
	var left_shape = RectangleShape2D.new()
	left_shape.size = Vector2(32, 1000)
	left_cs.shape = left_shape
	left_cs.position = Vector2(-50, GROUND_Y - 500)
	left_wall.add_child(left_cs)
	add_child(left_wall)

	# Right wall
	var right_wall = StaticBody2D.new()
	right_wall.name = "RightBound"
	var right_cs = CollisionShape2D.new()
	var right_shape = RectangleShape2D.new()
	right_shape.size = Vector2(32, 1000)
	right_cs.shape = right_shape
	right_cs.position = Vector2(LEVEL_WIDTH + 50, GROUND_Y - 500)
	right_wall.add_child(right_cs)
	add_child(right_wall)

func _setup_first_vision():
	print("Level 1: Sacred Grove — pits and boss")
	_add_pits()
	_add_death_zone()

func _setup_moroni():
	print("Level 2: Moroni's Visits — floating platforms")
	_add_floating_platforms()

func _setup_hill_cumorah():
	print("Level 3: Hill Cumorah — dig minigame")
	_add_dig_zone()

func _setup_printers_press():
	print("Level 4: Printer's Press — press-jump puzzles")
	_add_press_puzzle()

func _setup_fayette():
	print("Level 5: Church Organization — swim and chase")
	_add_swim_zone()

func _setup_kirtland():
	print("Level 6: Zion's Camp / Kirtland — temple climb")
	_add_temple_climb()

func _setup_nauvoo():
	print("Level 7: Nauvoo Exodus — river crossings and wagons")
	_add_wagons()

func _add_vines():
	var node = Node2D.new()
	node.name = "VineSwing"
	node.script = VINE_SCRIPT
	add_child(node)

func _add_vines_level_1():
	# Multiple vine placements for Level 1 Sacred Grove
	var vine_positions = [
		Vector2(250, 150),
		Vector2(450, 180),
		Vector2(650, 140),
		Vector2(850, 170)
	]
	for pos in vine_positions:
		var vine = Area2D.new()
		vine.name = "VineSwing_" + str(vine_positions.find(pos))
		vine.script = VINE_SCRIPT
		vine.position = pos
		
		# Add visual representation - thicker vine like Mario rope
		var line = Line2D.new()
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(0, 120))
		line.width = 8.0
		line.default_color = Color(0.5, 0.35, 0.1, 1.0)  # Brown rope
		vine.add_child(line)
		
		# Add vine knobs for visual interest
		for i in range(0, 120, 20):
			var knob = ColorRect.new()
			knob.size = Vector2(12, 12)
			knob.position = Vector2(-6, i)
			knob.color = Color(0.6, 0.4, 0.15, 1.0)
			vine.add_child(knob)
		
		add_child(vine)

func _add_death_zone():
	# Add kill zone below ground level
	var death_zone = Area2D.new()
	death_zone.name = "DeathZone"
	death_zone.position = Vector2(LEVEL_WIDTH / 2, GROUND_Y + 150)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(LEVEL_WIDTH, 100)
	collision.shape = shape
	death_zone.add_child(collision)
	
	death_zone.body_entered.connect(_on_player_fell)
	add_child(death_zone)

func _on_player_fell(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(999)  # Instant death

func _add_pits():
	# Pits are now created by gaps in the ground tiles (see _create_ground)
	# No visual blocks needed - just the holes in the ground
	pass

func _on_pit_entered(body):
	if body.is_in_group("player"):
		print("Player fell into a pit!")
		body.take_damage(50)

func _add_beam_pillar():
	# Create a sacred pillar platform at the end
	var pillar = Node2D.new()
	pillar.name = "SacredPillar"
	pillar.position = Vector2(1100, 300)
	
	# Base platform
	var base = StaticBody2D.new()
	var base_rect = ColorRect.new()
	base_rect.size = Vector2(120, 40)
	base_rect.position = Vector2(-60, 0)
	base_rect.color = Color(0.8, 0.7, 0.2, 1.0)  # Golden platform
	base.add_child(base_rect)
	
	var base_collision = CollisionShape2D.new()
	var base_shape = RectangleShape2D.new()
	base_shape.size = Vector2(120, 40)
	base_collision.position = Vector2(0, 20)
	base_collision.shape = base_shape
	base.add_child(base_collision)
	pillar.add_child(base)
	
	# Glowing pillar column
	var column = ColorRect.new()
	column.size = Vector2(60, 200)
	column.position = Vector2(-30, -200)
	column.color = Color(1.0, 0.85, 0.0, 1.0)  # Bright golden
	pillar.add_child(column)
	
	# Add glow effect with semi-transparent aura
	var aura = ColorRect.new()
	aura.size = Vector2(100, 250)
	aura.position = Vector2(-50, -230)
	aura.color = Color(1.0, 0.85, 0.0, 0.2)
	pillar.add_child(aura)
	
	add_child(pillar)

func _add_platforms_level_1():
	# Create a series of stepping stone platforms
	var platform_data = [
		Vector2(300, 350),   # Start platform
		Vector2(480, 320),   # Up
		Vector2(650, 340),   # Down
		Vector2(800, 310),   # Up
		Vector2(950, 360),   # Down
		Vector2(1100, 290),  # Up to pillar
	]
	
	for pos in platform_data:
		_create_platform(pos, Vector2(80, 20), Color(0.8, 0.6, 0.2, 1.0))

func _create_platform(pos: Vector2, size: Vector2, color: Color) -> void:
	var platform = StaticBody2D.new()
	platform.position = pos
	
	# Visual
	var visual = ColorRect.new()
	visual.size = size
	visual.position = -size / 2
	visual.color = color
	platform.add_child(visual)
	
	# Add decorative border
	var border_top = ColorRect.new()
	border_top.size = Vector2(size.x, 2)
	border_top.position = Vector2(-size.x / 2, -size.y / 2)
	border_top.color = Color.WHITE
	platform.add_child(border_top)
	
	# Collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	platform.add_child(collision)
	
	add_child(platform)

func _add_enemies_level_1():
	# Add a few enemies: walkers and archers across the level
	_spawn_simple_enemy(Vector2(600, 500))
	_spawn_archer_enemy(Vector2(1200, 500))
	_spawn_simple_enemy(Vector2(1800, 500))

func _spawn_simple_enemy(pos: Vector2) -> void:
	var enemy_scene: PackedScene = load("res://scenes/enemy/Enemy.tscn")
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = pos
		add_child(enemy)

func _spawn_archer_enemy(pos: Vector2) -> void:
	var archer_scene: PackedScene = load("res://scenes/enemy/EnemyArcher.tscn")
	if archer_scene:
		var archer = archer_scene.instantiate()
		archer.position = pos
		add_child(archer)

func _add_floating_platforms():
	for i in range(5):
		var p = StaticBody2D.new()
		p.script = FLOAT_SCRIPT
		p.position = Vector2(200 + i * 150, 300 - i * 30)
		
		# Add visual representation - platform from video aesthetic
		var rect = ColorRect.new()
		rect.size = Vector2(120, 16)
		rect.color = Color(0.745, 0.69, 0.74, 1.0)  # Stone/platform gray from video
		rect.position = Vector2(-60, -8)
		p.add_child(rect)
		
		# Add collision
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(120, 16)
		collision.shape = shape
		collision.position = Vector2(0, 0)
		p.add_child(collision)
		
		add_child(p)

func _add_dig_zone():
	var dz = Node2D.new()
	dz.script = DIG_SCRIPT
	dz.name = "DigZone"
	add_child(dz)

func _add_press_puzzle():
	var press = Node2D.new()
	press.script = PRESS_SCRIPT
	press.name = "PressPuzzle"
	add_child(press)

func _add_swim_zone():
	var swim = Node2D.new()
	swim.script = SWIM_SCRIPT
	swim.name = "SwimZone"
	add_child(swim)

func _add_temple_climb():
	var climb = Node2D.new()
	climb.script = TEMPLE_SCRIPT
	climb.name = "TempleClimb"
	add_child(climb)

func _add_wagons():
	for i in range(6):
		var wagon = Node2D.new()
		wagon.script = WAGON_SCRIPT
		wagon.position = Vector2(150 + i * 200, 360)
		add_child(wagon)

func _spawn_boss_if_any():
	# For level 1, use the new boss
	if level_id == 1:
		var boss_scene: PackedScene = load("res://scenes/enemies/Boss.tscn")
		if boss_scene:
			_create_boss_arena()
			var boss = boss_scene.instantiate()
			boss.position = Vector2(2700, 500)
			add_child(boss)
	elif BOSS_SCENES.has(level_id):
		var boss_scene = BOSS_SCENES[level_id]
		if boss_scene:
			_create_boss_arena()
			var boss = boss_scene.instantiate()
			boss.position = Vector2(1100, 180)
			add_child(boss)

func _on_boss_defeated() -> void:
	print("Boss defeated! Level complete.")
	var complete_screen = get_tree().current_scene.get_node_or_null("UILayer/LevelComplete")
	if complete_screen and complete_screen.has_method("show_complete"):
		complete_screen.show_complete()

func _create_boss_arena():
	# Create a distinct arena for the boss fight
	var arena = Node2D.new()
	arena.name = "BossArena"
	
	# Arena background (expanded for wider boss area)
	var bg = ColorRect.new()
	bg.size = Vector2(600, 300)
	bg.position = Vector2(2100, 0)
	bg.color = Color(0.2, 0.05, 0.15, 1.0)  # Dark purple
	arena.add_child(bg)
	
	# Platform for boss
	var boss_platform = StaticBody2D.new()
	boss_platform.position = Vector2(2400, 250)
	
	var platform_rect = ColorRect.new()
	platform_rect.size = Vector2(200, 20)
	platform_rect.position = Vector2(-100, 0)
	platform_rect.color = Color(0.7, 0.3, 0.1, 1.0)  # Dark red
	boss_platform.add_child(platform_rect)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(200, 20)
	collision.shape = shape
	boss_platform.add_child(collision)
	
	arena.add_child(boss_platform)
	add_child(arena)
