extends CharacterBody2D

@export var patrol_speed: float = 100.0
@export var chase_speed: float = 150.0
@export var vision_range: float = 250.0
@export var shoot_range: float = 200.0
@export var shoot_cooldown: float = 1.5
@export var damage: int = 15
@export var max_health: int = 20
var health: int

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 1
var patrol_left: float = -200.0
var patrol_right: float = 200.0
var shoot_timer: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	health = max_health
	add_to_group("enemies")
	if sprite and not sprite.sprite_frames:
		# Create simple placeholder sprite frames
		var frames = SpriteFrames.new()
		frames.add_animation("idle")
		sprite.sprite_frames = frames
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var player = _find_player()
	shoot_timer -= delta
	
	if player:
		var dist = global_position.distance_to(player.global_position)
		if dist <= vision_range:
			direction = sign(player.global_position.x - global_position.x)
			# Chase closer, but maintain distance for ranged attack
			if dist > shoot_range:
				velocity.x = direction * chase_speed
			else:
				velocity.x = 0.0  # Stand and shoot
			
			if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
				sprite.flip_h = direction < 0
				sprite.play("walk" if abs(velocity.x) > 10 else "idle")
			
			# Fire arrow at player
			if shoot_timer <= 0.0 and dist <= shoot_range:
				_shoot_arrow(player.global_position)
				shoot_timer = shoot_cooldown
		else:
			# Patrol
			velocity.x = direction * patrol_speed
			if global_position.x < patrol_left:
				direction = 1
			elif global_position.x > patrol_right:
				direction = -1
			if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
				sprite.flip_h = direction < 0
				sprite.play("walk")
	
	move_and_slide()

func _find_player() -> Node2D:
	var root = get_tree().current_scene
	if root and root.has_node("Player"):
		return root.get_node("Player")
	return null

func _shoot_arrow(target_pos: Vector2) -> void:
	var arrow_scene = preload("res://scenes/player/ScriptureProjectile.tscn")
	if not arrow_scene:
		return
	var arrow = arrow_scene.instantiate()
	arrow.global_position = global_position + Vector2(20 * direction, 0)
	# Set arrow velocity toward player
	var dir_to_player = (target_pos - arrow.global_position).normalized()
	arrow.velocity = dir_to_player * 300.0
	# Mark as enemy projectile so it doesn't collide with us
	arrow.add_to_group("enemy_projectile")
	get_tree().current_scene.add_child(arrow)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
