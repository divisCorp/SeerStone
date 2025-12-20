extends Area2D

const SPEED := 600.0
var damage := 10
var velocity := Vector2.ZERO
var direction := 1.0

func _ready() -> void:
	body_entered.connect(_on_hit)
	add_to_group("projectile")
	
	# Create gold plate visual
	if not has_node("Visual"):
		var plate = ColorRect.new()
		plate.name = "Visual"
		plate.size = Vector2(16, 24)
		plate.position = Vector2(-8, -12)
		plate.color = Color(0.85, 0.7, 0.2, 1.0)  # Gold
		add_child(plate)
		
		# Add engravings
		for i in range(3):
			var line = ColorRect.new()
			line.size = Vector2(12, 1)
			line.position = Vector2(-6, -8 + i * 4)
			line.color = Color(0.6, 0.5, 0.15, 1.0)
			plate.add_child(line)
		
		# Border highlight
		var border = ColorRect.new()
		border.size = Vector2(16, 2)
		border.position = Vector2(0, 0)
		border.color = Color(1.0, 0.9, 0.5, 1.0)
		plate.add_child(border)

func _physics_process(delta: float) -> void:
	if velocity.length() > 0:
		position += velocity * delta
	else:
		position.x += SPEED * direction * delta
	
	if position.x > get_viewport_rect().size.x + 100.0 or position.x < -100:
		queue_free()

func _on_hit(body: Node) -> void:
	if body != get_parent() and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
