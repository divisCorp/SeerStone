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

func _ready():
	_setup_world()
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
	
	var bg = ColorRect.new()
	bg.anchor_left = 0.0
	bg.anchor_top = 0.0
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.color = Color(0.053, 0.671, 0.973, 1.0)  # Video sky blue RGB(13, 171, 248)
	bg_canvas.add_child(bg)
	
	print("Background set to video sky blue")

func _spawn_player():
	var player = PLAYER_SCENE.instantiate()
	player.position = Vector2(100, 200)
	add_child(player)
	player.add_to_group("player")
	var cam = Camera2D.new()
	cam.zoom = Vector2(2, 2)
	player.add_child(cam)
	# Call make_current() after adding to tree
	cam.make_current()

func _create_ground():
	var ground = StaticBody2D.new()
	ground.name = "Ground"
	
	# Create collision
	var cs = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(2000, 32)
	cs.shape = rect
	ground.add_child(cs)
	
	# Create visual representation with reference video ground color
	var canvas_rect = ColorRect.new()
	canvas_rect.size = Vector2(2000, 32)
	canvas_rect.color = Color(0.184, 0.0, 0.082, 1.0)  # Video ground RGB(47, 0, 21)
	ground.add_child(canvas_rect)
	
	ground.position = Vector2(500, 400)
	add_child(ground)

func _setup_first_vision():
	print("Level 1: Sacred Grove — vine swings and dark pits")
	_add_vines_level_1()
	_add_beam_pillar()
	_add_pits()

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
		
		# Add visual representation (vertical line) - vine color from video
		var line = Line2D.new()
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(0, 100))
		line.width = 3.0
		line.default_color = Color(0.4, 0.6, 0.3, 1.0)  # Green vine
		vine.add_child(line)
		
		add_child(vine)

func _add_pits():
	# Pit zones that kill player if they fall in
	var pit_positions = [
		Vector2(350, 430),  # pit between vines 0 and 1
		Vector2(550, 430),  # pit between vines 1 and 2
		Vector2(750, 430),  # pit between vines 2 and 3
	]
	for pit_pos in pit_positions:
		var pit = Area2D.new()
		pit.name = "Pit"
		
		# Visual representation - dark pit color from video
		var rect = ColorRect.new()
		rect.size = Vector2(100, 100)
		rect.color = Color(0.1, 0.02, 0.08, 1.0)  # Very dark pit
		rect.position = Vector2(-50, 0)
		pit.add_child(rect)
		
		# Collision
		var cs = CollisionShape2D.new()
		var rect_shape = RectangleShape2D.new()
		rect_shape.size = Vector2(100, 100)
		cs.shape = rect_shape
		cs.position = Vector2(0, 50)
		pit.add_child(cs)
		
		pit.position = pit_pos
		pit.connect("body_entered", Callable(self, "_on_pit_entered"))
		add_child(pit)

func _on_pit_entered(body):
	if body.is_in_group("player"):
		print("Player fell into a pit!")
		body.take_damage(50)

func _add_beam_pillar():
	var pillar_scene = preload("res://scenes/objects/PillarOfLight.tscn")
	var pillar = pillar_scene.instantiate()
	pillar.name = "PillarOfLight"
	pillar.position = Vector2(900, 220)
	add_child(pillar)

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
	if BOSS_SCENES.has(level_id):
		var boss_scene = BOSS_SCENES[level_id]
		if boss_scene:
			var boss = boss_scene.instantiate()
			boss.position = Vector2(1100, 260)
			add_child(boss)
