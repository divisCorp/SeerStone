extends Node2D

var speed := 40
var dir := 1

func _physics_process(delta):
	position.x += speed * dir * delta
	if position.x < 50 or position.x > 1200:
		dir *= -1
