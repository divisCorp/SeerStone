extends Node2D

var health := 100
var vulnerable := false

func _ready():
	add_to_group("boss")

func take_damage(amount:int):
	if not vulnerable:
		return
	health -= amount
	_on_hit(amount)
	if health <= 0:
		die()

func set_vulnerable(state:bool):
	vulnerable = state
	if vulnerable:
		print("Boss is now vulnerable")
		_flash_vulnerable()
	else:
		print("Boss is no longer vulnerable")

func _flash_vulnerable():
	# visual cue: color flash placeholder
	print("*Boss flashes with a golden glow*")

func _on_hit(damage:int):
	print("*Boss takes ", damage, " damage! Health: ", health, "*")
	# visual: knockback or color flash
	print("*Boss staggers*")

func die():
	print("*Boss is defeated!*")
	_death_animation()
	_show_level_complete()

func _show_level_complete():
	# Trigger level complete screen
	var level = get_tree().current_scene
	if level:
		var ui_layer = level.get_node_or_null("UILayer")
		if ui_layer:
			var complete = ui_layer.get_child(1) if ui_layer.get_child_count() > 1 else null
			if complete and complete.has_method("show_level_complete"):
				var level_id = level.get("level_id") if level.has_meta("level_id") else 1
				complete.show_level_complete(level_id)

func _death_animation():
	# simple death: shrink and fade
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	queue_free()
