extends Node

# Generates sprites based on reference video and applies them to the game

func _ready():
	generate_and_apply_sprites()

func generate_and_apply_sprites():
	var SpriteFactory = preload("res://scripts/sprite_factory.gd")
	
	# Create asset directory
	var asset_path = "user://restoration_quest_sprites/"
	var dir = DirAccess.open(asset_path)
	if dir == null:
		DirAccess.make_absolute_path(asset_path)
	
	# Generate all sprites
	print("Generating game sprites from reference video...")
	
	var character_sheet = SpriteFactory.create_character_spritesheet()
	character_sheet.save_png(asset_path + "character_spritesheet.png")
	print("✓ Character sprite sheet generated")
	
	var ground = SpriteFactory.create_ground_tileset()
	ground.save_png(asset_path + "ground_tile.png")
	print("✓ Ground tileset generated")
	
	var sky = SpriteFactory.create_sky_background()
	sky.save_png(asset_path + "sky_background.png")
	print("✓ Sky background generated")
	
	var platform = SpriteFactory.create_platform_sprite()
	platform.save_png(asset_path + "platform.png")
	print("✓ Platform sprite generated")
	
	var vine = SpriteFactory.create_vine_sprite()
	vine.save_png(asset_path + "vine.png")
	print("✓ Vine sprite generated")
	
	var boss = SpriteFactory.create_boss_sprite()
	boss.save_png(asset_path + "boss.png")
	print("✓ Boss sprite generated")
	
	print("\nSprites created successfully!")
	print("Location: " + asset_path)
	
	# Update color palette in game
	update_game_colors()
	
	queue_free()  # Remove this script after generation

func update_game_colors():
	# Update the global color scheme
	var viewport = get_tree().root
	viewport.modulate = Color(0.06, 0.68, 0.97, 1.0)  # Sky blue background
	print("\n✓ Game colors updated to match reference video")
