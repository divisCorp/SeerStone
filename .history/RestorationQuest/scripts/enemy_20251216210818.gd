extends CharacterBody2D

@export var patrol_speed: float = 120.0
@export var chase_speed: float = 200.0
@export var vision_range: float = 220.0
@export var damage: int = 10
@export var max_health: int = 30
var health: int

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 1
var patrol_left: float = -200.0
var patrol_right: float = 200.0

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
	if player and global_position.distance_to(player.global_position) <= vision_range:
		# chase
		direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * chase_speed
		if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
			sprite.flip_h = direction < 0
			sprite.play("walk")
	else:
		# patrol between bounds
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

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
