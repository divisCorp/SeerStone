extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var faith_bar: ProgressBar = $CanvasLayer/FaithBar

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack"):
		shoot_scripture()
	
	if Input.is_action_pressed("pray"):
		faith_bar.value = min(100, faith_bar.value + 50 * delta)
	
	move_and_slide()

func shoot_scripture():
	var projectile_scene = preload("res://ScriptureProjectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position + Vector2(20, 0)
	get_tree().current_scene.add_child(projectile)
	
func take_damage(amount):
	faith_bar.value = max(0, faith_bar.value - amount)
	if faith_bar.value <= 0:
		queue_free()  # Game over logic later
