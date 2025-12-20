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
    
    # Based on the sprite sheet layout:
    # Approximately 3 columns, 4 rows
    cols = 3
    rows = 4
    cell_width = img.width // cols
    cell_height = img.height // rows
    
    print(f"Cell size: {cell_width}x{cell_height}")
    
    # Define which cells contain which animations
    # Format: (col, row)
    animations = {
        "idle": [(0, 0)],           # Just use first idle pose
        "walk": [(0, 1), (1, 1), (2, 1)],  # Row 1, all columns
        "jump": [(0, 2), (1, 2)],   # Row 2, first two columns  
        "attack": [(2, 2)],         # Row 2, last column
    }
    
    for anim_name, frames in animations.items():
        for idx, (col, row) in enumerate(frames):
            x_start = col * cell_width
            y_start = row * cell_height
            
            # Find actual sprite bounds within this cell
            bounds = find_sprite_bounds(img, x_start, y_start, cell_width, cell_height)
            
            if bounds:
                # Extract just the sprite, not the whole cell
                x, y, w, h = bounds
                frame = img.crop((
                    x_start + x,
                    y_start + y,
                    x_start + w,
                    y_start + h
                ))
                
                # Save frame
                output_path = os.path.join(output_dir, f"{anim_name}_frame_{idx:02d}.png")
                frame.save(output_path)
                print(f"Saved: {output_path} (size: {frame.width}x{frame.height})")
            else:
                print(f"Warning: No sprite found at ({col}, {row}) for {anim_name}")

if __name__ == "__main__":
    split_spritesheet()
    print("Done! Frames saved to assets/sprites/player_frames/")
