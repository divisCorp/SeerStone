# Restoration Quest — Godot 2D Prototype

A seven-level platformer inspired by Joseph Smith's restoration history. Each level features unique mechanics, challenges, and boss encounters tied to key historical events.

## Folder Structure

```
RestorationQuest/
├── scenes/
│   ├── Main.tscn                    # Entry point; press 1-7 to load levels
│   ├── player/                      # Player character & projectile
│   │   ├── player.tscn
│   │   ├── player.gd
│   │   ├── ScriptureProjectile.tscn
│   │   └── ScriptureProjectile.gd
│   ├── levels/                      # Level scenes (Level1.tscn ... Level7.tscn)
│   ├── enemies/                     # Boss scenes (Boss1.tscn ... Boss7.tscn + Beam.tscn)
│   └── objects/                     # Mechanic objects (PillarOfLight.tscn)
├── scripts/
│   ├── Main.gd                      # Scene loader
│   ├── levels/
│   │   ├── LevelBase.gd             # Base level class; spawns player, ground, mechanics
│   │   ├── Level1.gd ... Level7.gd  # Per-level configurations
│   ├── bosses/
│   │   ├── BossBase.gd              # Boss base with health & vulnerability
│   │   └── Boss1.gd ... Boss7.gd    # Per-boss AI and attacks
│   ├── enemies/
│   │   └── beam.gd                  # Beam projectile (Boss1 attack)
│   └── mechanics/
│       ├── vine_swing.gd            # Vine grappling mechanic
│       ├── pillar_of_light.gd       # Prayer pillar (reveals boss vulnerability)
│       ├── floating_platform.gd     # Moroni-level moving platforms
│       ├── dig_zone.gd              # Hill Cumorah dig minigame
│       ├── press_puzzle.gd          # Printer's Press jump puzzle
│       ├── swim_zone.gd             # Fayette baptism swim areas
│       ├── temple_climb.gd          # Kirtland temple climbing
│       └── wagon_platform.gd        # Nauvoo wagon platforms
├── project.godot
└── README.md
```

## How to Run

1. **Open in Godot 4** (requires Godot 4.x)
2. **Set Main scene**: Open `scenes/Main.tscn` and set it as the main scene
3. **Press 1-7 to load levels**:
   - Level 1: Sacred Grove (Vines + Pillar Boss)
   - Level 2: Moroni's Visits (Floating Platforms)
   - Level 3: Hill Cumorah (Dig Minigame)
   - Level 4: Printer's Press (Press Puzzles)
   - Level 5: Fayette Church (Swim Zones + Mob Chase)
   - Level 6: Kirtland Temple (Temple Climb)
   - Level 7: Nauvoo Exodus (Wagon Platforms)

## Controls

- **Arrow Keys**: Move left/right
- **Space**: Jump / Detach from vine
- **X**: Attack (shoot scripture projectile)
- **Z**: Pray (build faith; required to reveal boss vulnerability)

## Level 1 Walkthrough (Sacred Grove)

1. Use vines to swing across pits
2. Build faith by holding **Z** near the Pillar of Light
3. When boss becomes vulnerable (golden flash), attack with **X**
4. Defeat the boss by draining its health to zero
5. Boss shrinks and fades on defeat

## Features Implemented

✅ Player with grappling vine mechanics  
✅ 7 level scenes with unique mechanics  
✅ Boss base with vulnerability system  
✅ Beam attacks, pit hazards, death animations  
✅ Prayer pillar for boss reveal mechanic  
✅ Faith bar UI  
✅ Scripture projectile attacks

## Next Steps

- Add sprite graphics for player, bosses, and UI
- Implement audio feedback for attacks and level transitions
- Expand boss AI for levels 2-7
- Add level-complete screens and progression tracking
- Polish collision and camera behavior
