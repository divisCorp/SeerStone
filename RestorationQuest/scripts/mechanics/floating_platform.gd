extends Node2D

var amplitude := 40
var speed := 1.2
var origin := Vector2.ZERO

func _ready():
	origin = position

func _physics_process(delta):
	position.x = origin.x + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
