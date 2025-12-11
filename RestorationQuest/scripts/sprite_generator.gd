extends Node

# Sprite generation utility for creating simple 2D pixel art sprites
# This creates basic Image-based sprites that can be used for player, enemies, and environment

static func create_player_sprite() -> Image:
	# Create a simple player sprite based on reference image colors
	var img = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	
	# Colors from reference image
	var player_color = Color(123/255.0, 174/255.0, 219/255.0, 1.0)  # Light blue
	var skin_color = Color(241/255.0, 181/255.0, 144/255.0, 1.0)    # Peachy skin
	var dark_color = Color(51/255.0, 11/255.0, 22/255.0, 1.0)       # Dark brown
	
	# Head (circle approximation)
	for x in range(16, 32):
		for y in range(4, 16):
			var dist = sqrt(pow(x - 24, 2) + pow(y - 10, 2))
			if dist < 8:
				img.set_pixel(x, y, skin_color)
	
	# Body (rectangle)
	for x in range(18, 30):
		for y in range(16, 32):
			img.set_pixel(x, y, player_color)
	
	# Arms
	for x in range(10, 18):
		for y in range(18, 26):
			img.set_pixel(x, y, skin_color)
	for x in range(30, 38):
		for y in range(18, 26):
			img.set_pixel(x, y, skin_color)
	
	# Legs
	for x in range(18, 24):
		for y in range(32, 48):
			img.set_pixel(x, y, dark_color)
	for x in range(24, 30):
		for y in range(32, 48):
			img.set_pixel(x, y, dark_color)
	
	return img

static func create_ground_sprite(width: int = 1200, height: int = 100) -> Image:
	# Create textured ground based on reference image colors
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# Colors from reference image
	var ground_dark = Color(45/255.0, 15/255.0, 27/255.0, 1.0)      # Dark purple-brown
	var ground_light = Color(73/255.0, 39/255.0, 42/255.0, 1.0)     # Slightly lighter
	var dirt_color = Color(51/255.0, 11/255.0, 22/255.0, 1.0)       # Dark brown
	
	# Fill with base ground color and add texture
	for x in range(width):
		for y in range(height):
			# Create some variation with noise-like pattern
			if (x + y) % 3 == 0:
				img.set_pixel(x, y, ground_light)
			else:
				img.set_pixel(x, y, ground_dark)
			
			# Add darker streaks for texture
			if y < height // 2 and (x % 5 < 2):
				img.set_pixel(x, y, dirt_color)
	
	return img

static func create_background_sprite(width: int = 1200, height: int = 600) -> Image:
	# Create background based on reference image colors (sepia/vintage tone)
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# Colors from reference image
	var sky_blue = Color(73/255.0, 161/255.0, 248/255.0, 1.0)       # Bright blue (13.26% dominant)
	var sky_blue_dark = Color(41/255.0, 96/255.0, 137/255.0, 1.0)   # Darker blue
	var bg_brown = Color(115/255.0, 27/255.0, 13/255.0, 1.0)        # Dark reddish-brown
	
	# Create a sky with gradient and clouds
	for x in range(width):
		for y in range(height):
			var ratio = float(y) / float(height)
			
			# Main sky gradient
			var color = sky_blue.lerp(sky_blue_dark, ratio)
			
			# Add some cloud-like texture
			var cloud_factor = sin(x * 0.01 + y * 0.005) * 0.1 + 0.05
			color = color.lerp(Color.WHITE, cloud_factor)
			
			# Lower portion transitions to brownish
			if ratio > 0.7:
				color = color.lerp(bg_brown, (ratio - 0.7) / 0.3)
			
			img.set_pixel(x, y, color)
	
	return img

static func save_texture(img: Image, path: String) -> void:
	# Save image as PNG
	if not path.ends_with(".png"):
		path += ".png"
	img.save_png(path)
	print("Saved texture: ", path)
