extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH := 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const FOOT_MARGIN := 3.0
var health: int = MAX_HEALTH

@onready var faith_bar: ProgressBar = $CanvasLayer/FaithBar

# Grapple/vine state
var on_vine := false
var vine_anchor := Vector2.ZERO
var vine_radius := 0.0
var vine_angle := 0.0
var vine_angular_velocity := 0.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null

func _ready():
	# Load sprite animations from individual frames
	anim_sprite = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null
	if anim_sprite:
		var frames: SpriteFrames = SpriteFrames.new()
		
		# Define animations and their frame counts
		# Using single frames for now to avoid sprite bleeding issues
		var animations = {
			"idle": 1,
			"walk": 1,
			"jump": 1,
			"attack": 1
		}
		
		# Load each animation
		for anim_name in animations.keys():
			frames.add_animation(anim_name)
			var frame_count = animations[anim_name]
			
			for i in range(frame_count):
				var frame_path = "res://assets/sprites/player_frames/%s_frame_%02d.png" % [anim_name, i]
				if ResourceLoader.exists(frame_path):
					var texture = load(frame_path) as Texture2D
					if texture:
						frames.add_frame(anim_name, texture)
		
		# Set walk animation FPS
		frames.set_animation_speed("walk", 8.0)
		frames.set_animation_speed("idle", 4.0)
		
		anim_sprite.sprite_frames = frames
		anim_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		anim_sprite.centered = true
		anim_sprite.offset = Vector2.ZERO
		
		# Position sprite so feet align with character origin
		# The sprite should be positioned above the origin point
		anim_sprite.position = Vector2(0, -16)
		
		anim_sprite.animation = "idle"
		anim_sprite.play()
		
		if not anim_sprite.is_connected("animation_finished", Callable(self, "_on_sprite_animation_finished")):
			anim_sprite.connect("animation_finished", Callable(self, "_on_sprite_animation_finished"))

func _physics_process(delta):
	if on_vine:
		# swing physics (simple pendulum)
		var dir_input = Input.get_axis("ui_left", "ui_right")
		vine_angular_velocity += dir_input * 3.0 * delta
		vine_angular_velocity += -0.5 * sin(vine_angle) * delta * 6.0
		vine_angular_velocity *= 0.995
		vine_angle += vine_angular_velocity
		# update position from anchor
		position = vine_anchor + Vector2(vine_radius * sin(vine_angle), vine_radius * cos(vine_angle))
		if Input.is_action_just_pressed("jump"):
			# detach with impulse
			on_vine = false
			velocity = Vector2(vine_angular_velocity * 200, -200)
		# allow praying while on vine
		if Input.is_action_pressed("pray"):
			faith_bar.value = min(100, faith_bar.value + 50 * delta)
	else:
		if not is_on_floor():
			velocity.y += gravity * delta

		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * SPEED

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if Input.is_action_just_pressed("attack"):
			shoot_scripture()
			if anim_sprite and anim_sprite.sprite_frames and anim_sprite.sprite_frames.has_animation("attack"):
				anim_sprite.play("attack")

		if Input.is_action_pressed("pray"):
			faith_bar.value = min(100, faith_bar.value + 50 * delta)

		move_and_slide()

	_update_animation_state()
	
	# Pause menu input
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause()

func _update_animation_state():
	if anim_sprite == null or anim_sprite.sprite_frames == null:
		return
	# prioritize explicit animations (attack), otherwise pick based on motion
	if anim_sprite.animation == "attack" and anim_sprite.is_playing():
		return
	if on_vine or not is_on_floor():
		if anim_sprite.sprite_frames.has_animation("jump"):
			anim_sprite.play("jump")
			return
	var dir = Input.get_axis("ui_left", "ui_right")
	if abs(dir) > 0.1 and anim_sprite.sprite_frames.has_animation("walk"):
		anim_sprite.flip_h = dir < 0
		anim_sprite.play("walk")
	else:
		if anim_sprite.sprite_frames.has_animation("idle"):
			anim_sprite.play("idle")

func _on_sprite_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		if anim_sprite and anim_sprite.sprite_frames and anim_sprite.sprite_frames.has_animation("idle"):
			anim_sprite.play("idle")

func shoot_scripture():
	var projectile_scene = preload("res://scenes/player/ScriptureProjectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position + Vector2(20, 0)
	get_tree().current_scene.add_child(projectile)

func show_game_over():
	# Trigger game over screen
	var level = get_tree().current_scene
	if level:
		var ui_layer = level.get_node_or_null("UILayer")
		if ui_layer:
			var gameover = ui_layer.get_child(2) if ui_layer.get_child_count() > 2 else null
			if gameover and gameover.has_method("show_game_over"):
				var level_id = level.get("level_id") if level.has_meta("level_id") else 1
				gameover.show_game_over(level_id)

func _toggle_pause():
	var level = get_tree().current_scene
	if level:
		var ui_layer = level.get_node_or_null("UILayer")
		if ui_layer:
			var pause_menu = ui_layer.get_child(0)
			if pause_menu and pause_menu.has_method("show_pause_menu"):
				pause_menu.show_pause_menu()

func attach_to_vine(anchor:Vector2):
	on_vine = true
	vine_anchor = anchor
	vine_radius = (global_position - anchor).length()
	vine_angle = atan2(global_position.x - anchor.x, global_position.y - anchor.y)
	vine_angular_velocity = 0.0

func take_damage(amount: int) -> void:
	health -= amount
	set_meta("health", health)
	print("Player damaged! Health: %d" % health)
	if health <= 0:
		queue_free()

func _clean_sprite_frames_alpha() -> void:
	if anim_sprite == null:
		return
	var frames_res = anim_sprite.sprite_frames
	if frames_res == null:
		return

	for anim_name in frames_res.get_animation_names():
		var count = frames_res.get_frame_count(anim_name)
		for i in range(count):
			var tex = frames_res.get_frame_texture(anim_name, i)
			if tex == null:
				continue
			if not tex.has_method("get_data"):
				continue
			var img = tex.get_data()
			if img == null:
				continue
			var w = img.get_width()
			var h = img.get_height()
			if w == 0 or h == 0:
				continue
			var key_col = img.get_pixel(0, 0)
			var changed = false
			for y in range(h):
				for x in range(w):
					var p = img.get_pixel(x, y)
					# compare by exact equality for pixel art backgrounds
					if p.r == key_col.r and p.g == key_col.g and p.b == key_col.b and p.a == key_col.a:
						img.set_pixel(x, y, Color(p.r, p.g, p.b, 0.0))
						changed = true
			if changed:
				var new_tex = ImageTexture.create_from_image(img)
				frames_res.set_frame_texture(anim_name, i, new_tex)
