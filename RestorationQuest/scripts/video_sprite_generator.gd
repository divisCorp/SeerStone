extends Node

# Create sprites that match the reference video exactly
# Colors extracted from actual video frames

const VIDEO_SKY_BLUE = Color(0.053, 0.671, 0.973, 1.0)      # RGB(13, 171, 248)
const VIDEO_CHARACTER_GREEN = Color(0.055, 0.973, 0.02, 1.0)  # RGB(14, 248, 5) - Bright neon green
const VIDEO_GROUND_DARK = Color(0.184, 0.0, 0.082, 1.0)      # RGB(47, 0, 21)
const VIDEO_GOLD = Color(0.996, 0.843, 0.2, 1.0)             # RGB(254, 215, 51)

# Create character sprite that matches the video
static func create_video_character_sprite(width: int = 64, height: int = 96) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# Fill with transparent
	for x in range(width):
		for y in range(height):
			img.set_pixel(x, y, Color(0, 0, 0, 0))
	
	# Head
	for x in range(20, 44):
		for y in range(10, 28):
			var dist = sqrt(pow(x - 32, 2) + pow(y - 19, 2))
			if dist < 14:
				img.set_pixel(x, y, VIDEO_CHARACTER_GREEN)
	
	# Body
	for x in range(18, 46):
		for y in range(28, 70):
			img.set_pixel(x, y, VIDEO_CHARACTER_GREEN)
	
	# Arms
	for x in range(8, 18):
		for y in range(32, 58):
			img.set_pixel(x, y, VIDEO_CHARACTER_GREEN)
	for x in range(46, 56):
		for y in range(32, 58):
			img.set_pixel(x, y, VIDEO_CHARACTER_GREEN)
	
	# Legs
	for x in range(22, 30):
		for y in range(70, 96):
			img.set_pixel(x, y, VIDEO_CHARACTER_GREEN)
	for x in range(34, 42):
		for y in range(70, 96):
			img.set_pixel(x, y, VIDEO_CHARACTER_GREEN)
	
	return img

# Create simple ground sprite
static func create_video_ground_sprite(width: int = 800, height: int = 100) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	for x in range(width):
		for y in range(height):
			img.set_pixel(x, y, VIDEO_GROUND_DARK)
	
	return img

# Create platform sprite
static func create_video_platform_sprite(width: int = 120, height: int = 20) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	var platform_color = Color(0.5, 0.5, 0.5, 1.0)  # Gray platform
	
	for x in range(width):
		for y in range(height):
			img.set_pixel(x, y, platform_color)
	
	return img

static func save_video_sprites():
	print("Creating video-accurate sprites...")
	
	var char_sprite = create_video_character_sprite()
	char_sprite.save_png("user://video_character.png")
	print("✓ Character sprite saved")
	
	var ground = create_video_ground_sprite()
	ground.save_png("user://video_ground.png")
	print("✓ Ground sprite saved")
	
	var platform = create_video_platform_sprite()
	platform.save_png("user://video_platform.png")
	print("✓ Platform sprite saved")
	
	print("\nVideo-accurate color palette:")
	print("  Sky: RGB(13, 171, 248)")
	print("  Character: RGB(14, 248, 5) - Bright neon green")
	print("  Ground: RGB(47, 0, 21)")
	print("  Gold UI: RGB(254, 215, 51)")
