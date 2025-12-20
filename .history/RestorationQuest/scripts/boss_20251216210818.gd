extends CharacterBody2D

@export var patrol_speed: float = 80.0
@export var charge_speed: float = 400.0
@export var vision_range: float = 300.0
@export var max_health: int = 100
@export var charge_cooldown: float = 2.5
var health: int
var charge_timer: float = 0.0
var is_charging: bool = false
var charge_direction: int = 1

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 1
var patrol_left: float = -150.0
var patrol_right: float = 150.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	health = max_health
	add_to_group("boss")
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
	charge_timer -= delta
	
	if is_charging:
		# Charge at player
		velocity.x = charge_direction * charge_speed
		if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("attack"):
			sprite.flip_h = charge_direction < 0
			sprite.play("attack")
	elif player and global_position.distance_to(player.global_position) <= vision_range:
		# Prepare charge attack
		charge_direction = sign(player.global_position.x - global_position.x)
		is_charging = true
		charge_timer = charge_cooldown
		
		if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
			sprite.flip_h = charge_direction < 0
			sprite.play("walk")
	else:
		# Patrol
		velocity.x = direction * patrol_speed
		if global_position.x < patrol_left:
			direction = 1
		elif global_position.x > patrol_right:
			direction = -1
		is_charging = false
		if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
			sprite.flip_h = direction < 0
			sprite.play("walk")
	
	move_and_slide()
	
	# Stop charging after duration
	if is_charging and charge_timer <= 0:
		is_charging = false
		velocity.x = 0

func _find_player() -> Node2D:
	var root = get_tree().current_scene
	if root and root.has_node("Player"):
		return root.get_node("Player")
	return null

func take_damage(amount: int) -> void:
	health -= amount
	print("Boss hit! Health: %d/%d" % [health, max_health])
	if health <= 0:
		_on_boss_defeated()

func _on_boss_defeated() -> void:
	print("Boss defeated!")
	queue_free()
	var root = get_tree().current_scene
	if root and root.has_method("_on_boss_defeated"):
		root._on_boss_defeated()
