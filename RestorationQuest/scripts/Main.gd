extends Node2D

func _ready():
	print("Restoration Quest: Press number 1-7 to load levels")

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var kc = event.keycode
		if kc == KEY_1:
			get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")
		elif kc == KEY_2:
			get_tree().change_scene_to_file("res://scenes/levels/Level2.tscn")
		elif kc == KEY_3:
			get_tree().change_scene_to_file("res://scenes/levels/Level3.tscn")
		elif kc == KEY_4:
			get_tree().change_scene_to_file("res://scenes/levels/Level4.tscn")
		elif kc == KEY_5:
			get_tree().change_scene_to_file("res://scenes/levels/Level5.tscn")
		elif kc == KEY_6:
			get_tree().change_scene_to_file("res://scenes/levels/Level6.tscn")
		elif kc == KEY_7:
			get_tree().change_scene_to_file("res://scenes/levels/Level7.tscn")
