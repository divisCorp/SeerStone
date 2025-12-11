extends Area2D

var speed := 0
var damage := 15
var lifetime := 3.0

func _ready():
	# add a collision shape if none
	if not has_node("CollisionShape2D"):
		var cs = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(8, 300)
		cs.shape = rect
		cs.position = Vector2(0, 150)
		add_child(cs)
	connect("body_entered", Callable(self, "_on_body_entered"))
	set_physics_process(true)

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
