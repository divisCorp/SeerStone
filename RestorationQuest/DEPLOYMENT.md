# Deployment Checklist

Use this checklist before releasing the game.

## Pre-Release Quality Assurance

### Code & Build
- [x] No compile/parse errors (`get_errors` returns 0 issues)
- [x] All scenes load without crashes
- [x] Player spawns and responds to input
- [x] Animations display correctly (idle, walk, jump, attack)
- [x] Faith bar updates visibly
- [x] Boss 1 appears and responds to attacks

### Gameplay (Level 1 Test)
- [x] Player can move left/right
- [x] Player can jump
- [x] Player can swing on vines
- [x] Player can pray (Z key builds faith)
- [x] Boss becomes vulnerable after sufficient faith
- [x] Boss takes damage from scripture projectiles (X key)
- [x] Boss dies and level completes cleanly

### Asset & Performance
- [x] Sprites load without errors
- [x] Animation frames are smooth (no stuttering)
- [x] Frame rate is acceptable (30+ FPS on reference machine)
- [x] No missing textures or audio glitches

### Documentation
- [x] README.md is clear and up-to-date
- [x] BUILDING.md covers setup and customization
- [x] Controls are documented in both files
- [x] License is specified (or note "TBD")

### Project Cleanliness
- [x] Temporary files removed (.DS_Store, __pycache__, *.tmp, etc.)
- [x] .gitignore is comprehensive and current
- [x] No debug print statements left in production code
- [x] Project structure is organized and documented

---

## Distribution Preparation

### For Web Deployment

```bash
# 1. Export HTML5
godot --headless --export-release "Web" export/web/index.html

# 2. Test exported version locally
cd export/web
python3 -m http.server 8000
# Open http://localhost:8000 in browser

# 3. Verify gameplay works identically
# - Run through Level 1 completely
# - Check animations, controls, boss fight

# 4. Upload to hosting service
# - Copy contents of export/web/ to your server
```

### For Desktop Deployment

```bash
# 1. Export for each platform
godot --headless --export-release "Windows Desktop" export/windows/game.exe
godot --headless --export-release "macOS" export/macos/game.app
godot --headless --export-release "Linux/X11" export/linux/game.x86_64

# 2. Test each binary locally
./export/windows/game.exe      # On Windows
./export/macos/game.app        # On macOS
./export/linux/game.x86_64     # On Linux

# 3. Create installers (optional)
# - Windows: Use NSIS or MSI wrapper
# - macOS: Create .dmg
# - Linux: Package as .deb, .rpm, or tarball

# 4. Sign executables (optional but recommended)
# - Windows: Code signing certificate
# - macOS: Apple Developer signing
```

### For GitHub Release

```bash
# 1. Tag the release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# 2. Create GitHub release
# - Go to Releases tab
# - Click "Draft a new release"
# - Attach built binaries and HTML5 zip

# 3. Include release notes
# - What's new
# - Known issues
# - Installation instructions
```

---

## Post-Release Monitoring

- [ ] Monitor GitHub issues for bug reports
- [ ] Collect user feedback on gameplay
- [ ] Track performance metrics (if applicable)
- [ ] Plan updates/patches based on feedback

---

**Release Date**: [To be filled in]  
**Version**: 1.0.0  
**Status**: Ready to Ship ✅
