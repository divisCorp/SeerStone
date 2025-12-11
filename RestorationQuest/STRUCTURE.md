# Project Structure Guide

## Overview

Restoration Quest is organized using Godot's standard folder hierarchy: scenes and scripts separated, with subfolders per feature/system.

## Directory Layout

### Root Level
- `project.godot` — Godot project configuration
- `icon.svg` — Project icon
- `README.md` — User-facing documentation
- `STRUCTURE.md` — This file

### `/scenes/` — Scene Files
All `.tscn` files are organized by feature:

#### `/scenes/player/`
- `player.tscn` / `player.gd` — Player character with grappling mechanics
- `ScriptureProjectile.tscn` / `ScriptureProjectile.gd` — Attack projectile

#### `/scenes/levels/`
- `Level1.tscn` ... `Level7.tscn` — Level scenes (paired with `scripts/levels/Level1.gd` ... `Level7.gd`)

#### `/scenes/enemies/`
- `Boss1.tscn` ... `Boss7.tscn` — Boss scenes (paired with `scripts/bosses/Boss1.gd` ... `Boss7.gd`)
- `Beam.tscn` — Boss attack projectile

#### `/scenes/objects/`
- `PillarOfLight.tscn` — Prayer pillar mechanic (Level 1)

### `/scripts/` — Code Files
Organization mirrors `/scenes/`:

#### `/scripts/` (Root)
- `Main.gd` — Game entry point; level loader via number keys 1-7

#### `/scripts/levels/`
- `LevelBase.gd` — Base class for all levels; spawns player, ground, mechanics, boss
- `Level1.gd` ... `Level7.gd` — Per-level configuration (set `level_id` and call parent `_ready()`)

#### `/scripts/bosses/`
- `BossBase.gd` — Boss base class with health, damage, vulnerability, death animation
- `Boss1.gd` ... `Boss7.gd` — Per-boss AI and attack patterns

#### `/scripts/enemies/`
- `beam.gd` — Beam projectile behavior

#### `/scripts/mechanics/`
Per-level mechanics as separate scripts (assigned to placeholder nodes in `LevelBase`):
- `vine_swing.gd` — Level 1: Grappling mechanics
- `pillar_of_light.gd` — Level 1: Prayer-based boss reveal
- `floating_platform.gd` — Level 2: Moving platforms
- `dig_zone.gd` — Level 3: Dig minigame
- `press_puzzle.gd` — Level 4: Button/platform puzzles
- `swim_zone.gd` — Level 5: Swimming speed modifier
- `temple_climb.gd` — Level 6: Climbing mechanics
- `wagon_platform.gd` — Level 7: Moving wagon platforms

## Naming Conventions

- **Scenes**: `PascalCase.tscn` (e.g., `Player.tscn`, `Boss1.tscn`)
- **Scripts**: `snake_case.gd` (e.g., `player.gd`, `vine_swing.gd`)
- **Groups**: `lowercase` (e.g., `"player"`, `"boss"`, `"enemies"`)

## How Scenes Load

1. **Entry Point**: `scenes/Main.tscn` with `Main.gd`
2. **User Input**: Press 1-7 to trigger scene change
3. **Level Creation**: `LevelBase._ready()` instantiates:
   - Player from `scenes/player/player.tscn`
   - Ground StaticBody2D
   - Level-specific mechanics (vines, platforms, puzzles, etc.)
   - Boss from `scenes/enemies/BossX.tscn`

## File References (Import Paths)

All `preload()` statements use resource paths:
- `preload("res://scenes/player/player.tscn")` — Player scene
- `preload("res://scenes/enemies/Boss1.tscn")` — Boss 1 scene
- `preload("res://scripts/mechanics/vine_swing.gd")` — Vine script

## Deprecated/Legacy Files

The following files at the root level are **deprecated** and should be ignored (listed in `.gitignore`):
- `player.gd`, `player.tscn` (use `scenes/player/player.tscn`)
- `ScriptureProjectile.gd`, `ScriptureProjectile.tscn` (use `scenes/player/ScriptureProjectile.tscn`)
- `scripts/boss.gd`, `scripts/enemy.gd` (use `scripts/bosses/` and `scripts/enemies/`)

## Adding New Levels

To add Level 8:
1. Create `scenes/levels/Level8.tscn` referencing `Level8.gd`
2. Create `scripts/levels/Level8.gd` extending `LevelBase.gd`, set `level_id = 8`
3. Override `_setup_*()` in `Level8.gd` if custom setup is needed
4. Create `scripts/bosses/Boss8.gd` extending `BossBase.gd`
5. Create `scenes/enemies/Boss8.tscn` referencing `Boss8.gd`
6. Update `scripts/levels/LevelBase.gd` BOSS_SCENES dict to include Boss8

## Adding New Mechanics

To add a new mechanic (e.g., `push_block`):
1. Create `scripts/mechanics/push_block.gd`
2. In the level's `_setup_*()` method, instantiate and attach the script to a Node2D
3. Example in `LevelBase._add_wagons()` — can use as template

---

**Last updated**: Dec 10, 2025  
**Project**: Restoration Quest (Godot 4.5)
