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

func _death_animation():
	# simple death: shrink and fade
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	queue_free()
