#!/usr/bin/env python3
"""
Split JospehSprite.png sprite sheet into individual animation frames.
"""

from PIL import Image
import os

def split_spritesheet():
    sprite_path = "../assets/sprites/JospehSprite.png"
    output_dir = "../assets/sprites/player_frames"
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Load sprite sheet
    img = Image.open(sprite_path)
    
    # Looking at the sprite sheet:
    # Row 1 (0-2): Idle frames (3 frames, facing different directions)
    # Row 2 (3-5): Walk frames (3 frames)
    # Row 3 (6-7): Jump frames (2 frames)
    # Row 4+: Attack/special frames
    
    # Approximate frame size (will need to adjust based on actual sprite)
    frame_width = img.width // 3  # 3 columns
    frame_height = img.height // 4  # approximately 4 rows
    
    animations = {
        "idle": [(0, 0), (1, 0), (2, 0)],  # Row 0, columns 0-2
        "walk": [(0, 1), (1, 1), (2, 1)],  # Row 1, columns 0-2
        "jump": [(0, 2), (1, 2)],           # Row 2, columns 0-1
        "attack": [(2, 2)],                 # Row 2, column 2
    }
    
    for anim_name, frames in animations.items():
        for idx, (col, row) in enumerate(frames):
            x = col * frame_width
            y = row * frame_height
            
            # Extract frame
            frame = img.crop((x, y, x + frame_width, y + frame_height))
            
            # Remove extra space around sprite
            bbox = frame.getbbox()
            if bbox:
                frame = frame.crop(bbox)
            
            # Save frame
            output_path = os.path.join(output_dir, f"{anim_name}_frame_{idx:02d}.png")
            frame.save(output_path)
            print(f"Saved: {output_path}")

if __name__ == "__main__":
    split_spritesheet()
    print("Done! Frames saved to assets/sprites/player_frames/")
