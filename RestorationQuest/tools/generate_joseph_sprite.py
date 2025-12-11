from PIL import Image
import os

os.makedirs('assets/sprites', exist_ok=True)

# Pixel-art Joseph Smith (simple, respectful silhouette)
W, H = 48, 64
img = Image.new('RGBA', (W, H), (0,0,0,0))
pixel = img.load()

# Colors
hair = (60,40,20,255)
coat = (20,20,40,255)
shirt = (240,240,240,255)
face = (237,203,167,255)
trouser = (30,30,30,255)

# Simple pixel layout (centered)
# Draw head
for y in range(6, 14):
    for x in range(18, 30):
        pixel[x,y] = face
# hair top
for y in range(4,10):
    for x in range(16,32):
        if pixel[x,y][3] == 0:
            pixel[x,y] = hair
# body / coat
for y in range(14,42):
    for x in range(12,36):
        pixel[x,y] = coat
# shirt (V collar)
for y in range(20,28):
    for x in range(22,26):
        pixel[x,y] = shirt
# trousers
for y in range(42,60):
    for x in range(16,32):
        pixel[x,y] = trouser
# simple arms (coat sleeves)
for y in range(22,36):
    for x in range(8,12):
        pixel[x,y] = coat
    for x in range(36,40):
        pixel[x,y] = coat

out_path = 'assets/sprites/joseph.png'
img.save(out_path)
print('Saved', out_path)
