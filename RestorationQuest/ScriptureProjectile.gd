extends Area2D

const SPEED = 600.0
var damage = 10

func _ready():
	body_entered.connect(_on_hit)

func _physics_process(delta):
	position.x += SPEED * delta
	if position.x > get_viewport_rect().size.x + 100:
		queue_free()

func _on_hit(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	queue_free()
