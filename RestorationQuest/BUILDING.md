# Building & Development Guide

## Requirements

- **Godot 4.x** (tested with 4.5.1)
- **Python 3.8+** (for animation generation scripts)
- **Pillow** (`pip install Pillow`) — for sprite generation
- **OpenCV** (`pip install opencv-python`) — for frame extraction

## Development Setup

1. **Clone and open the project**
   ```bash
   git clone <repo-url>
   cd RestorationQuest
   godot .
   ```

2. **Set main scene**
   - In Godot editor: `Project → Project Settings → Main Scene`
   - Set to `res://scenes/Main.tscn`

3. **Run**
   - Press `F5` or click the Play button
   - In-game: Press `1-7` to jump to a level, or progress naturally

## Regenerating Animations

If you modify video frames or want to rebuild animations:

1. **Extract frames from video** (optional, if you have a new video)
   ```bash
   python3 tools/extract_video_frames.py <video_file>
   ```

2. **Build pixel-art animation frames**
   ```bash
   python3 tools/build_joseph_animations.py
   ```
   This creates `assets/sprites/joseph_idle_frame_*.png`, `joseph_walk_frame_*.png`, etc.

3. **Save SpriteFrames resource** (optional, for editor visibility)
   ```bash
   # Inside Godot editor:
   # - Add a Node to any scene, attach tools/save_joseph_spriteframes.gd
   # - Run the scene or call _run() in the debugger console
   ```
   This creates `assets/sprites/joseph_animations.tres`.

## Project Structure

```
RestorationQuest/
├── assets/sprites/              # Generated pixel-art frames & spritesheet
│   ├── joseph_idle_frame_*.png
│   ├── joseph_walk_frame_*.png
│   ├── joseph_jump_frame_*.png
│   ├── joseph_attack_frame_*.png
│   └── joseph_animations.tres   # Saved SpriteFrames resource
├── scenes/                      # Scene files (.tscn)
│   ├── Main.tscn                # Entry point / level selector
│   ├── player/                  # Player & projectile scenes
│   ├── levels/                  # Level scenes (Level1–7)
│   └── enemies/                 # Boss scenes
├── scripts/                     # GDScript files
│   ├── Main.gd                  # Main scene controller
│   ├── levels/                  # LevelBase + per-level configs
│   ├── bosses/                  # BossBase + per-boss AI
│   ├── mechanics/               # Gameplay mechanics
│   ├── animation_loader.gd      # Runtime animation loader
│   └── (generated helpers)      # Sprite generators (legacy)
├── tools/                       # Python build scripts
│   ├── build_joseph_animations.py      # Frame grouping
│   ├── extract_video_frames.py         # Video extraction
│   ├── build_joseph_animation.py       # Legacy frame builder
│   ├── generate_joseph_sprite.py       # Static sprite generator
│   └── save_joseph_spriteframes.gd     # SpriteFrames saver
├── project.godot                # Godot project config
├── README.md                    # User-facing guide
└── BUILDING.md                  # This file
```

## Building for Distribution

### Export for Web (HTML5)

```bash
# In Godot editor:
# File → Export Project → Web
# Choose destination folder
# Godot generates an .html file
```

Then host the exported files on any web server.

### Export for Desktop

```bash
# In Godot editor:
# File → Export Project → [Windows / macOS / Linux]
# Choose destination folder
# Godot generates standalone executables
```

Alternatively, use the command line:

```bash
godot --headless --export-release "Web" export/web/index.html
godot --headless --export-release "Windows Desktop" export/windows/game.exe
godot --headless --export-release "macOS" export/macos/game.app
```

## Customization

### Adjusting Animation Speed

Edit `scripts/animation_loader.gd`:
```gdscript
var default_speeds = {"idle":6, "walk":12, "jump":10, "attack":14}
```

### Changing Level Layout

Edit the corresponding `scripts/levels/Level[N].gd` to modify:
- Ground platforms (`ground_height`, `ground_width`)
- Vines (`vine_positions`, `vine_radius`)
- Bosses (`boss_position`, `boss_health`)
- Hazards (pits, spikes, etc.)

### Tweaking Boss Behavior

Edit `scripts/bosses/Boss[N].gd`:
- Attack patterns
- Movement speed
- Health pool
- Vulnerability duration

## Troubleshooting

### "Could not resolve script" errors

Make sure all script imports use `ResourceLoader.exists()` + `load()` instead of `preload()`:

```gdscript
# ✅ Good
var loader_path = "res://scripts/animation_loader.gd"
if ResourceLoader.exists(loader_path):
    var loader_script = load(loader_path)
    var loader = loader_script.new()

# ❌ Bad (causes compile-time resolution errors)
var loader = preload("res://scripts/animation_loader.gd").new()
```

### Animation frames not loading

1. Verify frames exist: `assets/sprites/joseph_idle_frame_*.png`, etc.
2. Check animation_loader.gd is in `res://scripts/`
3. Rebuild with `python3 tools/build_joseph_animations.py`

### Game won't start

1. Check `project.godot` — verify `main_scene = "res://scenes/Main.tscn"`
2. Run error check: `Ctrl+Shift+M` in editor to see all errors
3. Check console output for warnings

## Contributing

1. Create a feature branch: `git checkout -b feature/my-feature`
2. Make changes and test locally
3. Commit with clear messages: `git commit -am "Add feature X"`
4. Push and open a Pull Request

## License

[Add your license here if applicable]

---

For gameplay questions, see [README.md](README.md).
