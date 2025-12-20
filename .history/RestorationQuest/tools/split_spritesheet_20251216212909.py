#!/usr/bin/env python3
"""
Split JospehSprite.png sprite sheet into individual animation frames.
"""

from PIL import Image
import os

def find_sprite_bounds(img, x_start, y_start, max_width, max_height):
    """Find the actual bounds of a sprite by detecting non-transparent pixels"""
    pixels = img.load()
    
    # Find the bounding box of non-transparent/non-background pixels
    min_x, min_y = max_width, max_height
    max_x, max_y = 0, 0
    
    found_pixel = False
    for y in range(y_start, min(y_start + max_height, img.height)):
        for x in range(x_start, min(x_start + max_width, img.width)):
            pixel = pixels[x, y]
            # Check if pixel is not transparent and not pure blue background
            if len(pixel) >= 4:
                is_visible = pixel[3] > 128  # Alpha check
            else:
                is_visible = True
            
            # Skip blue background (RGB: 102, 204, 255 or similar)
            if is_visible and not (pixel[0] < 150 and pixel[1] > 150 and pixel[2] > 200):
                found_pixel = True
                rel_x = x - x_start
                rel_y = y - y_start
                min_x = min(min_x, rel_x)
                min_y = min(min_y, rel_y)
                max_x = max(max_x, rel_x)
                max_y = max(max_y, rel_y)
    
    if not found_pixel:
        return None
    
    # Calculate sprite width
    sprite_width = max_x - min_x + 1
    
    # Limit width to avoid capturing adjacent sprites
    # Typical character is around 60-80px wide
    max_allowed_width = 85
    if sprite_width > max_allowed_width:
        # Center the crop around the middle of the detected sprite
        center = (min_x + max_x) // 2
        half_width = max_allowed_width // 2
        min_x = max(0, center - half_width)
        max_x = min(max_width - 1, center + half_width)
    
    # Add small padding
    padding = 2
    min_x = max(0, min_x - padding)
    min_y = max(0, min_y - padding)
    max_x = min(max_width - 1, max_x + padding)
    max_y = min(max_height - 1, max_y + padding)
    
    return (min_x, min_y, max_x + 1, max_y + 1)

def split_spritesheet():
    sprite_path = "../assets/sprites/JospehSprite.png"
    output_dir = "../assets/sprites/player_frames"
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Load sprite sheet
    img = Image.open(sprite_path)
    print(f"Image size: {img.width}x{img.height}")
    
    # Manually define exact coordinates for each character
    # Format: (x, y, width, height) - pixel-perfect positions
    # Based on 409x610 image with 3 cols, ~4 rows
    # Each character is roughly 60-70px wide, positioned within 136px cells
    
    animations = {
        "idle": [(160, 10, 70, 140)],      # Middle character, row 0 - manually adjusted
        "walk": [(160, 10, 70, 140)],      # Same as idle for now
        "jump": [(160, 315, 70, 140)],     # Middle character, row 2 - manually adjusted
        "attack": [(295, 315, 70, 140)],   # Right character, row 2 - manually adjusted
    }
    
    for anim_name, frames in animations.items():
        for idx, (x, y, w, h) in enumerate(frames):
            # Extract the specific region
            frame = img.crop((x, y, x + w, y + h))
            
            # Trim any remaining transparent edges
            bbox = frame.getbbox()
            if bbox:
                frame = frame.crop(bbox)
            
            # Save frame
            output_path = os.path.join(output_dir, f"{anim_name}_frame_{idx:02d}.png")
            frame.save(output_path)
            print(f"Saved: {output_path} (size: {frame.width}x{frame.height})")

if __name__ == "__main__":
    split_spritesheet()
    print("Done! Frames saved to assets/sprites/player_frames/")
