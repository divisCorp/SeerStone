extends Node

# Sprite factory based on reference video analysis
# Colors extracted from the video frames

const SKY_BLUE = Color(0.06, 0.68, 0.97, 1.0)  # RGB(15, 173, 247)
const GROUND_DARK = Color(0.2, 0.0, 0.087, 1.0)  # RGB(51, 0, 22)
const CHARACTER_SKIN = Color(0.745, 0.69, 0.74, 1.0)  # RGB(190, 176, 189)
const CHARACTER_ACCENT = Color(0.957, 0.675, 0.53, 1.0)  # RGB(244, 172, 135)

# Create an animated character sprite sheet
static func create_character_spritesheet() -> Image:
	var sheet_width = 192  # 4 poses × 48 width
	var sheet_height = 48
	var img = Image.create(sheet_width, sheet_height, false, Image.FORMAT_RGBA8)
	
	# Fill with transparent background
	for x in range(sheet_width):
		for y in range(sheet_height):
			img.set_pixel(x, y, Color(0, 0, 0, 0))
	
	# Create 4 different character poses
	# Frame 0: Idle
	_draw_character_pose(img, 0, 0, 48, 48, "idle")
	# Frame 1: Walking
	_draw_character_pose(img, 48, 0, 48, 48, "walk")
	# Frame 2: Jumping
	_draw_character_pose(img, 96, 0, 48, 48, "jump")
	# Frame 3: Falling
	_draw_character_pose(img, 144, 0, 48, 48, "fall")
	
	return img

static func _draw_character_pose(img: Image, offset_x: int, offset_y: int, w: int, h: int, pose: String):
	# Draw character with vintage sepia aesthetic
	
	# Head
	for x in range(16, 32):
		for y in range(8, 18):
			var dist = sqrt(pow(x - 24, 2) + pow(y - 13, 2))
			if dist < 8:
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
	
	# Body/Robe
	for x in range(14, 34):
		for y in range(18, 36):
			img.set_pixel(offset_x + x, offset_y + y, CHARACTER_ACCENT)
	
	# Arms based on pose
	if pose == "idle":
		# Arms down
		for x in range(8, 14):
			for y in range(20, 32):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
		for x in range(34, 40):
			for y in range(20, 32):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
	elif pose == "walk":
		# Arms swinging
		for x in range(6, 12):
			for y in range(18, 28):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
		for x in range(36, 42):
			for y in range(26, 36):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
	elif pose == "jump":
		# Arms raised
		for x in range(6, 12):
			for y in range(10, 22):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
		for x in range(36, 42):
			for y in range(10, 22):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
	elif pose == "fall":
		# Arms falling
		for x in range(8, 14):
			for y in range(18, 32):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
		for x in range(34, 40):
			for y in range(18, 32):
				img.set_pixel(offset_x + x, offset_y + y, CHARACTER_SKIN)
	
	# Legs
	for x in range(18, 24):
		for y in range(36, 48):
			img.set_pixel(offset_x + x, offset_y + y, Color(0.1, 0.1, 0.1, 1.0))
	for x in range(24, 30):
		for y in range(36, 48):
			img.set_pixel(offset_x + x, offset_y + y, Color(0.1, 0.1, 0.1, 1.0))

# Create ground tileset
static func create_ground_tileset(width: int = 64, height: int = 64) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# Dark ground base
	var ground_color = GROUND_DARK
	var ground_lighter = Color(0.22, 0.04, 0.12, 1.0)  # Slightly lighter variant
	
	for x in range(width):
		for y in range(height):
			# Checkerboard pattern for visual interest
			if ((x / 8) + (y / 8)) % 2 == 0:
				img.set_pixel(x, y, ground_color)
			else:
				img.set_pixel(x, y, ground_lighter)
			
			# Add some texture noise
			if (x + y) % 3 == 0:
				img.set_pixel(x, y, ground_color.darkened(0.1))
	
	return img

# Create background/sky texture
static func create_sky_background(width: int = 1200, height: int = 600) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# Gradient from bright sky blue to darker blue
	var sky_bright = SKY_BLUE
	var sky_dark = Color(0.02, 0.41, 0.55, 1.0)  # Darker blue for depth
	
	for x in range(width):
		for y in range(height):
			var ratio = float(y) / float(height)
			var color = sky_bright.lerp(sky_dark, ratio)
			
			# Add subtle cloud pattern
			var cloud_pattern = sin(x * 0.005 + y * 0.002) * 0.1
			color = color.lerp(Color.WHITE, max(0, cloud_pattern))
			
			img.set_pixel(x, y, color)
	
	return img

# Create platform sprite
static func create_platform_sprite(width: int = 120, height: int = 16) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	var platform_color = Color(0.74, 0.69, 0.74, 1.0)  # Stone/platform gray
	var platform_dark = platform_color.darkened(0.2)
	
	# Top edge highlight
	for x in range(width):
		img.set_pixel(x, 0, platform_color.lightened(0.1))
	
	# Main platform
	for x in range(width):
		for y in range(1, height - 1):
			img.set_pixel(x, y, platform_color)
	
	# Bottom edge shadow
	for x in range(width):
		img.set_pixel(x, height - 1, platform_dark)
	
	return img

# Create vine sprite
static func create_vine_sprite(width: int = 8, height: int = 200) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	var vine_color = Color(0.4, 0.6, 0.3, 1.0)  # Greenish vine
	var vine_dark = vine_color.darkened(0.2)
	
	for x in range(width):
		for y in range(height):
			if x < 2:
				img.set_pixel(x, y, vine_dark)
			else:
				img.set_pixel(x, y, vine_color)
	
	return img

# Create boss sprite
static func create_boss_sprite(width: int = 64, height: int = 64) -> Image:
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# Boss has a more threatening appearance
	var boss_color = Color(0.6, 0.3, 0.15, 1.0)  # Dark reddish-brown
	var boss_accent = Color(0.8, 0.4, 0.2, 1.0)  # Lighter accent
	
	# Large body
	for x in range(12, 52):
		for y in range(12, 52):
			var dist = sqrt(pow(x - 32, 2) + pow(y - 32, 2))
			if dist < 20:
				img.set_pixel(x, y, boss_color)
	
	# Eyes
	for x in range(22, 26):
		img.set_pixel(x, 26, boss_accent)
	for x in range(38, 42):
		img.set_pixel(x, 26, boss_accent)
	
	return img

static func save_all_sprites(base_path: String = "res://assets/sprites/"):
	var path = base_path
	
	# Create directory
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_absolute_path(path)
	
	# Generate and save sprites
	var character_sheet = create_character_spritesheet()
	character_sheet.save_png(path + "character_spritesheet.png")
	
	var ground = create_ground_tileset()
	ground.save_png(path + "ground_tile.png")
	
	var sky = create_sky_background()
	sky.save_png(path + "sky_background.png")
	
	var platform = create_platform_sprite()
	platform.save_png(path + "platform.png")
	
	var vine = create_vine_sprite()
	vine.save_png(path + "vine.png")
	
	var boss = create_boss_sprite()
	boss.save_png(path + "boss.png")
	
	print("All sprites saved to " + path)
