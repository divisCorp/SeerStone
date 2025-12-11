extends Node

# Loads generated joseph animation frames into a SpriteFrames resource and assigns them
# to an AnimatedSprite2D node. It looks for files named `joseph_<anim>_frame_##.png`
# in the specified directory and creates one animation per `<anim>`.

func _collect_animation_files(dir_path: String) -> Dictionary:
	var d = DirAccess.open(dir_path)
	var result: Dictionary = {}
	if d == null:
		push_error("Directory not found: " + dir_path)
		return result

	d.list_dir_begin()
	var fname = d.get_next()
	var re = RegEx.new()
	re.compile("^joseph_(\\w+)_frame_(\\d+)\\.png$")
	while fname != "":
		if fname.ends_with('.png'):
			var m = re.search(fname)
			if m:
				var anim_name = m.get_string(1)
				var idx = int(m.get_string(2))
				if not result.has(anim_name):
					result[anim_name] = []
				# build resource path by joining dir_path and filename
				var full = dir_path + "/" + fname
				result[anim_name].append({"i": idx, "name": full})
		fname = d.get_next()
	d.list_dir_end()
	return result

func create_sprite_frames_from_dir(dir_path: String) -> SpriteFrames:
	var sf = SpriteFrames.new()
	var groups = _collect_animation_files(dir_path)
	if groups.is_empty():
		# fallback: try old pattern joseph_anim_frame_XX
		var i = 0
		var fallback = []
		while true:
			var idx = i
			var idx_str = "0" + str(idx) if idx < 10 else str(idx)
			var name = "joseph_anim_frame_" + idx_str + ".png"
			var p = dir_path + "/" + name
			if ResourceLoader.exists(p):
				fallback.append(p)
				i += 1
			else:
				break
		if not fallback.empty():
			sf.add_animation("idle")
			for p in fallback:
				sf.add_frame("idle", load(p))
			sf.set_animation_speed("idle", 8)
		else:
			push_warning("No joseph frames found in " + dir_path)
		return sf

	# For each group, sort by index and add animation
	var default_speeds = {"idle":6, "walk":12, "jump":10, "attack":14}
	for anim_name in groups.keys():
		var items = groups[anim_name]
		items.sort_custom(self, "_cmp_items")
		sf.add_animation(anim_name)
		for it in items:
			var tex = load(it.name)
			sf.add_frame(anim_name, tex)
		var spd = default_speeds.get(anim_name, 8)
		sf.set_animation_speed(anim_name, spd)

	return sf

func apply_to_player(player_node: Node):
	if not player_node:
		return
	var anim = player_node.get_node_or_null("AnimatedSprite2D")
	if anim == null:
		anim = AnimatedSprite2D.new()
		player_node.add_child(anim)

	# Prefer a pre-saved SpriteFrames resource if present
	var saved_path = "res://assets/sprites/joseph_animations.tres"
	var sf: SpriteFrames = null
	if ResourceLoader.exists(saved_path):
		var loaded = load(saved_path)
		if loaded and loaded is SpriteFrames:
			sf = loaded

	if sf == null:
		sf = create_sprite_frames_from_dir("res://assets/sprites")
	anim.frames = sf
	# Choose a sensible default animation
	if sf.has_animation("idle"):
		anim.animation = "idle"
	else:
		var anames = sf.get_animation_names()
		if anames.size() > 0:
			anim.animation = anames[0]
	anim.play()

	# Hide legacy Sprite2D/ColorRect visuals
	if player_node.has_node("Sprite2D"):
		player_node.get_node("Sprite2D").hide()
	if player_node.has_node("CharacterVisual"):
		player_node.get_node("CharacterVisual").hide()

	print("Applied joseph animation to player")

func _cmp_items(a, b):
	return int(a["i"]) - int(b["i"]) 
