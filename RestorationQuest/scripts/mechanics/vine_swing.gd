extends Area2D

@export var anchor_offset := Vector2(0, -80)

func _ready():
	if has_node("CollisionShape2D") == false:
		var cs = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(32, 120)
		cs.shape = rect
		add_child(cs)
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		var anchor_global = global_position + anchor_offset
		if body.has_method("attach_to_vine"):
			body.attach_to_vine(anchor_global)
			print("Player attached to vine at", anchor_global)
