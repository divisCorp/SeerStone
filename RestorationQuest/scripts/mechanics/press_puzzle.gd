extends Node2D

var toggles := []

func _ready():
	print("Press puzzle: time jumps to avoid ink rivers")

func press_toggle(id:int):
	if id in toggles:
		toggles.erase(id)
	else:
		toggles.append(id)
	if toggles.size() >= 3:
		print("Press puzzle solved")
		queue_free()
