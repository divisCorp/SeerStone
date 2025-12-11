tool
extends Node

"""
Editor/run-time helper: build and save a SpriteFrames `.tres` from the
generated joseph_<anim>_frame_##.png files in `res://assets/sprites`.

Usage:
- Open Godot editor, add this script to a Node and press the run button
  or run via CLI: `godot --script tools/save_joseph_spriteframes.gd` (if available).
"""

func _run():
    var loader_path = "res://scripts/animation_loader.gd"
    if not ResourceLoader.exists(loader_path):
        push_error("animation_loader.gd not found: " + loader_path)
        return
    var loader_script = load(loader_path)
    if not loader_script:
        push_error("Failed to load animation_loader.gd")
        return
    var loader = loader_script.new()
    var sf = loader.create_sprite_frames_from_dir("res://assets/sprites")
    if sf == null:
        push_error("Failed to create SpriteFrames")
        return
    var out_path = "res://assets/sprites/joseph_animations.tres"
    var err = ResourceSaver.save(out_path, sf)
    if err == OK:
        print("Saved SpriteFrames to " + out_path)
    else:
        push_error("Failed to save SpriteFrames: %s" % str(err))

func _enter_tree():
    # allow running by selecting this node and clicking 'Play Scene' in editor
    if Engine.is_editor_hint():
        print("save_joseph_spriteframes.gd loaded in editor. Call _run() to create resource.")
