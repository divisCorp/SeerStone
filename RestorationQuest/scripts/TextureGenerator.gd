extends Node

# Generates and applies textures to the game at startup
# Run this once to create sprite textures, then you can customize them

func _ready():
	generate_all_textures()

func generate_all_textures():
	# Import the sprite generator
	var SpriteGen = preload("res://scripts/sprite_generator.gd")
	
	# Create texture directory if it doesn't exist
	var dir = DirAccess.open("res://assets")
	if dir == null:
		DirAccess.make_absolute_path("res://assets")
	
	# Generate player texture
	var player_img = SpriteGen.create_player_sprite()
	player_img.save_png("user://player_texture.png")
	print("Generated player texture")
	
	# Generate ground texture
	var ground_img = SpriteGen.create_ground_sprite()
	ground_img.save_png("user://ground_texture.png")
	print("Generated ground texture")
	
	# Generate background texture
	var bg_img = SpriteGen.create_background_sprite()
	bg_img.save_png("user://background_texture.png")
	print("Generated background texture")
	
	print("All textures generated! Check user:// directory")
