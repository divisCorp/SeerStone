extends Area2D

@export var vulnerable_duration := 6.0
@export var faith_threshold := 30

var players := []
var active_timer := 0.0
var boss_ref = null

func _ready():
	if not has_node("CollisionShape2D"):
		var cs = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(120, 220)
		cs.shape = rect
		cs.position = Vector2(0, 110)
		add_child(cs)
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		players.append(body)

func _on_body_exited(body):
	if body in players:
		players.erase(body)

func _process(delta):
	if players.size() == 0:
		return
	# check if any player is pressing pray and has enough faith
	for p in players:
		if p and p.is_inside_tree():
			if Input.is_action_pressed("pray"):
				var faith_val = 0
				if p.has_node("CanvasLayer/FaithBar"):
					faith_val = p.get_node("CanvasLayer/FaithBar").value
				elif p.has_method("get_faith"):
					faith_val = p.get_faith()
				if faith_val >= faith_threshold:
					_reveal(boss_ref)

func _reveal(boss_node):
	if boss_node == null:
		var bosses = get_tree().get_nodes_in_group("boss")
		if bosses.size() == 0:
			return
		boss_node = bosses[0]
	boss_node.set_vulnerable(true)
	active_timer = vulnerable_duration
	set_process(true)

func _physics_process(delta):
	if active_timer > 0:
		active_timer -= delta
		if active_timer <= 0:
			var bosses = get_tree().get_nodes_in_group("boss")
			if bosses.size() > 0:
				bosses[0].set_vulnerable(false)
				print("Pillar's light fades...")
			active_timer = 0

func _emit_particles():
	# visual feedback: print for now, could add CPUParticles2D
	print("Pillar glows with divine light")
