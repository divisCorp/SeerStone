extends "res://scripts/bosses/BossBase.gd"

const BEAM_SCENE = preload("res://scenes/enemies/Beam.tscn")

var attack_timer := 0.0
var attack_interval := 2.0

func _ready():
	super._ready()
	set_process(true)

func _physics_process(delta):
	if vulnerable:
		# when vulnerable, boss pauses offensive attacks
		return
	attack_timer += delta
	if attack_timer > attack_interval:
		attack_timer = 0
		_shoot_beam()

func _shoot_beam():
	var beam = BEAM_SCENE.instantiate()
	# place beam below boss to simulate pillar-like beam
	beam.position = global_position + Vector2(0, 40)
	get_parent().add_child(beam)
	print("Boss1 fires a beam")

func set_vulnerable(state:bool):
	super.set_vulnerable(state)
	if state:
		attack_timer = 0
		# could add visuals/sound here
