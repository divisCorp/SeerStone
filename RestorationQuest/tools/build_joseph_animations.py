#!/usr/bin/env python3
"""
Create trimmed animation frame sets from the raw `joseph_anim_frame_XX.png` timeline.

It reads `assets/sprites/joseph_anim_frame_%02d.png` and writes grouped frames:
 - assets/sprites/joseph_idle_frame_00..N.png
 - assets/sprites/joseph_walk_frame_00..N.png
 - assets/sprites/joseph_jump_frame_00..N.png
 - assets/sprites/joseph_attack_frame_00..N.png

Adjust ranges below if you want different trims.
"""
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SRC_PREFIX = ROOT / 'assets' / 'sprites' / 'joseph_anim_frame_'

# Define ranges (inclusive start, inclusive end)
ANIM_RANGES = {
    'idle': (0, 3),
    'walk': (4, 9),
    'jump': (10, 12),
    'attack': (13, 16),
}

OUT_DIR = ROOT / 'assets' / 'sprites'
OUT_DIR.mkdir(parents=True, exist_ok=True)

def load_frame(idx):
    p = SRC_PREFIX.with_name(SRC_PREFIX.name + f"{idx:02d}.png")
    if not p.exists():
        return None
    return Image.open(p)

def save_anim(anim_name, start, end):
    written = 0
    for i, src_idx in enumerate(range(start, end+1)):
        img = load_frame(src_idx)
        if img is None:
            continue
        out_name = OUT_DIR / f"joseph_{anim_name}_frame_{i:02d}.png"
        img.save(out_name)
        written += 1
    return written

def main():
    total = 0
    for name, (s,e) in ANIM_RANGES.items():
        w = save_anim(name, s, e)
        print(f"Wrote {w} frames for {name}")
        total += w
    print(f"Total frames written: {total}")

if __name__ == '__main__':
    main()
