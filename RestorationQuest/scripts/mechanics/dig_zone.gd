extends Node2D

var progress := 0
var required := 3

func _ready():
	print("Dig zone ready: press 'attack' near zone to dig")

func _input(event):
	if event.is_action_pressed("attack"):
		var player = get_parent().get_node_or_null("Player")
		# simple: increment progress when attack pressed
		progress += 1
		print("Digging... ", progress, "/", required)
		if progress >= required:
			print("Found the plates!")
			queue_free()
