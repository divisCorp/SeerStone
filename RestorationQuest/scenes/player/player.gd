extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var faith_bar: ProgressBar = $CanvasLayer/FaithBar

# Grapple/vine state
var on_vine := false
var vine_anchor := Vector2.ZERO
var vine_radius := 0.0
var vine_angle := 0.0
var vine_angular_velocity := 0.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null

func _ready():
	# If a custom Joseph sprite exists in the project, load it for the player
	var joseph_path = "res://assets/sprites/joseph.png"
	if FileAccess.file_exists(joseph_path):
		var tex = load(joseph_path)
		if has_node("Sprite2D"):
			$Sprite2D.texture = tex

	# Apply generated animation frames (if present)
	var loader_path = "res://scripts/animation_loader.gd"
	if ResourceLoader.exists(loader_path):
		var loader_script = load(loader_path)
		if loader_script:
			var loader = loader_script.new()
			loader.apply_to_player(self)
	anim_sprite = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null
	if anim_sprite:
		# ensure we can detect when attack animation ends
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
			if anim_sprite and anim_sprite.frames and anim_sprite.frames.has_animation("attack"):
				anim_sprite.play("attack")

		if Input.is_action_pressed("pray"):
			faith_bar.value = min(100, faith_bar.value + 50 * delta)

		move_and_slide()

	_update_animation_state()

func _update_animation_state():
	if anim_sprite == null or anim_sprite.frames == null:
		return
	# prioritize explicit animations (attack), otherwise pick based on motion
	if anim_sprite.animation == "attack" and anim_sprite.is_playing():
		return
	if on_vine or not is_on_floor():
		if anim_sprite.frames.has_animation("jump"):
			anim_sprite.play("jump")
			return
	var dir = Input.get_axis("ui_left", "ui_right")
	if abs(dir) > 0.1 and anim_sprite.frames.has_animation("walk"):
		anim_sprite.flip_h = dir < 0
		anim_sprite.play("walk")
	else:
		if anim_sprite.frames.has_animation("idle"):
			anim_sprite.play("idle")

func _on_sprite_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		if anim_sprite and anim_sprite.frames and anim_sprite.frames.has_animation("idle"):
			anim_sprite.play("idle")

func shoot_scripture():
	var projectile_scene = preload("res://scenes/player/ScriptureProjectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position + Vector2(20, 0)
	get_tree().current_scene.add_child(projectile)

func take_damage(amount):
	faith_bar.value = max(0, faith_bar.value - amount)
	if faith_bar.value <= 0:
		print("Player defeated (faith depleted)")
		queue_free()  # Game over logic later

func attach_to_vine(anchor:Vector2):
	on_vine = true
	vine_anchor = anchor
	vine_radius = (global_position - anchor).length()
	vine_angle = atan2(global_position.x - anchor.x, global_position.y - anchor.y)
	vine_angular_velocity = 0.0
