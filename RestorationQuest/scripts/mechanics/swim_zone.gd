extends Area2D

var swim_speed := 140

func _ready():
	if has_node("CollisionShape2D") == false:
		var cs = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(800, 120)
		cs.shape = rect
		add_child(cs)
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.SPEED = swim_speed
		print("Player entered swim zone: reduced speed")

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.SPEED = 300
		print("Player left swim zone: restored speed")
