from PIL import Image
import os

IN_DIR = 'video_frames'
OUT_DIR = 'assets/sprites'
os.makedirs(OUT_DIR, exist_ok=True)

# Parameters for cropping/resizing to pixel-art
OUT_W, OUT_H = 48, 64
CROP_W, CROP_H = 200, 320  # region to crop around center (assumes character near center)

frames = sorted([f for f in os.listdir(IN_DIR) if f.endswith('.png')])
if not frames:
    print('No frames found in', IN_DIR)
    raise SystemExit(1)

out_frames = []
for i, f in enumerate(frames):
    path = os.path.join(IN_DIR, f)
    img = Image.open(path).convert('RGBA')
    w, h = img.size
    # crop centered box
    cx, cy = w//2, h//2
    left = max(0, cx - CROP_W//2)
    upper = max(0, cy - CROP_H//2)
    right = min(w, left + CROP_W)
    lower = min(h, upper + CROP_H)
    crop = img.crop((left, upper, right, lower))
    # resize to small nearest-neighbor to get pixel-art
    small = crop.resize((OUT_W, OUT_H), resample=Image.NEAREST)
    # optional color quantize to reduce palette (keeps look)
    #small = small.convert('P', palette=Image.ADAPTIVE, colors=32).convert('RGBA')
    out_name = f'joseph_anim_frame_{i:02d}.png'
    out_path = os.path.join(OUT_DIR, out_name)
    small.save(out_path)
    out_frames.append(out_name)
    print('Saved', out_path)

# build a horizontal spritesheet
sheet_w = OUT_W * len(out_frames)
sheet_h = OUT_H
sheet = Image.new('RGBA', (sheet_w, sheet_h), (0,0,0,0))
for i, name in enumerate(out_frames):
    im = Image.open(os.path.join(OUT_DIR, name)).convert('RGBA')
    sheet.paste(im, (i*OUT_W, 0))

sheet_path = os.path.join(OUT_DIR, 'joseph_anim.png')
sheet.save(sheet_path)
print('Saved spritesheet', sheet_path)
print('Frames written:', len(out_frames))
