# App Store Readiness Checklist

## ✅ Completed (Phase 1: Core UI & Navigation)

### Menus & Screens
- ✅ **Main Menu** (`scenes/menu/MainMenu.tscn` + MainMenu.gd)
  - Title screen
  - Play button (starts Level 1)
  - Level select button (quick jump to any level 1-7)
  - Settings button (placeholder)
  - Credits button
  - Quit button

- ✅ **Pause Menu** (`scenes/ui/PauseMenu.tscn` + PauseMenu.gd)
  - ESC key toggles pause during gameplay
  - Resume, Settings, Quit to Menu options
  - Properly pauses and resumes game state

- ✅ **Level Complete Screen** (`scenes/ui/LevelComplete.tscn` + LevelComplete.gd)
  - Displayed when boss is defeated
  - Shows current level number
  - "Continue" button (next level or menu if Level 7)
  - Back to Menu option
  - Handles end-game transition

- ✅ **Game Over Screen** (`scenes/ui/GameOver.tscn` + GameOver.gd)
  - Displayed when player faith reaches 0
  - Retry current level
  - Back to Menu option
  - Proper pause state management

### Code Integration
- ✅ Updated `project.godot` to use MainMenu as main scene
- ✅ Modified `LevelBase.gd` to instantiate UI overlays at runtime
- ✅ Updated `player.gd` to handle pause input (ESC) and trigger game over
- ✅ Modified `BossBase.gd` to trigger level complete on death
- ✅ All UI screens properly manage `get_tree().paused` state

---

## 🔄 In Progress (Phase 2: Content Polish)

### High Priority (Required for App Store)

1. **Complete All 7 Levels** (Currently only Level 1 fully playable)
   - [ ] Ensure Levels 2–7 have functional bosses
   - [ ] Add basic level geometry to each
   - [ ] Test each level for crashes/soft locks
   - [ ] Balance difficulty per level

2. **Visual Polish**
   - [ ] Add screen shake on boss hits
   - [ ] Particle effects (attack hit, level complete)
   - [ ] Smooth camera transitions between scenes
   - [ ] Button hover/focus states in menus
   - [ ] Loading screens between levels (optional)

3. **Audio System** (Critical for app store)
   - [ ] Background music (looping tracks for menu, levels, boss fights)
   - [ ] SFX: attack hit, boss death, level complete, UI clicks
   - [ ] Audio settings toggle (volume, mute)
   - [ ] Recommendations: Use free royalty-free music (OpenGameArt, etc.)

4. **Performance Optimization**
   - [ ] Check frame rate (target 60 FPS on mobile, 120+ on desktop)
   - [ ] Profile memory usage
   - [ ] Optimize draw calls (batch sprites, reduce dynamic lights)
   - [ ] Test on target platforms

5. **User Feedback & Polish**
   - [ ] Clearer on-screen prompts (e.g., "Press Z to Pray")
   - [ ] Tutorial/help screen (explain controls & mechanics)
   - [ ] Consistent font sizes and colors
   - [ ] Accessibility: high contrast mode, colorblind options

### Medium Priority (Nice to Have)

- [ ] Difficulty selector (Easy/Normal/Hard)
- [ ] Level progression tracking (save which levels completed)
- [ ] Leaderboard/scoring system
- [ ] Achievements/unlockables
- [ ] Controller support (gamepad input)

---

## ⏳ Not Started (Phase 3: App Store Submission)

### Required Before Release

1. **App Store Assets**
   - [ ] App icon (128x128, 512x512, 1024x1024 minimum)
   - [ ] Screenshots (3–5 per platform showing gameplay, menu, bosses)
   - [ ] Promotional graphic/banner
   - [ ] Game description text (2–3 paragraphs)

2. **Legal & Metadata**
   - [ ] Privacy Policy (even if no data collection, some stores require it)
   - [ ] EULA/Terms of Service (optional but recommended)
   - [ ] Copyright notice & credits
   - [ ] Age rating (ESRB, PEGI, etc. — likely T for Teen or E10+)
   - [ ] Version number (v1.0.0)
   - [ ] Build number (increment per release)

3. **Platform-Specific**
   - [ ] **Web (itch.io/GitHub Pages)**
     - Export to HTML5
     - Host on server
     - Add game page with description

   - **Windows (Steam/itch.io)**
     - Export `.exe` with installer
     - Windows code signing certificate (recommended)
     - Game description + screenshots

   - **macOS (App Store / GitHub)**
     - Export `.app` bundle
     - notarization (required for modern macOS)
     - GateKeeper signing

   - **Linux (itch.io/GitHub)**
     - Export `.x86_64` binary
     - AppImage packaging (optional)

   - **Mobile (iOS/Android)**
     - [ ] If targeting, export APK (Android) / IPA (iOS)
     - [ ] App store setup (Google Play, App Store)
     - [ ] Device testing
     - [ ] Touch control optimization

4. **Quality Assurance (QA)**
   - [ ] Playtest on all target platforms
   - [ ] Test all menus and transitions
   - [ ] Verify level progression works (1→2→...→7→End)
   - [ ] Check for crashes, soft locks, missing assets
   - [ ] Performance testing
   - [ ] Language/locale testing (if multilingual)

---

## 📋 Post-Launch Maintenance

- [ ] Monitor error logs
- [ ] Collect user feedback
- [ ] Plan bugfix releases
- [ ] Plan feature updates

---

## Current Status: **PHASE 1.5** ✅

**What's Ready:**
- ✅ Gameplay mechanics (movement, combat, prayer)
- ✅ Level 1 fully playable with boss
- ✅ Main menu & navigation
- ✅ Pause/resume system
- ✅ Game over & level complete screens
- ✅ Godot 4 build compatibility
- ✅ Core documentation (README, BUILDING)

**What's Needed for Launch:**
1. Complete Levels 2–7 (get them playable, not necessarily perfect)
2. Add audio (music + SFX)
3. Visual polish (effects, screen shake, etc.)
4. Performance testing & optimization
5. App store assets (icon, screenshots, description)

**Estimated Timeline:**
- Phase 2 (polish): 1–2 weeks
- Phase 3 (app store prep): 3–5 days

---

## Quick Commands

### Export for Testing

```bash
# Web (HTML5)
godot --headless --export-release "Web" export/web/index.html

# Windows
godot --headless --export-release "Windows Desktop" export/windows/game.exe

# macOS
godot --headless --export-release "macOS" export/macos/game.app

# Linux
godot --headless --export-release "Linux/X11" export/linux/game.x86_64
```

### Upload to itch.io

```bash
# Install butler: https://itch.io/app
butler push export/web/ divisCorp/restorationquest:html5
butler push export/windows/ divisCorp/restorationquest:windows
butler push export/macos/ divisCorp/restorationquest:macos
butler push export/linux/ divisCorp/restorationquest:linux
```

---

**Next Step:** Focus on completing Levels 2–7 and adding audio. See BUILDING.md for development setup.
