extends Reference
# Detector recursivo de modelos de personaje y escenarios instalados en res://models.
# Acepta GLB/GLTF dentro de cualquier subcarpeta creada al extraer los ZIP.

const NOT_CHARACTER = ["furniture", "muebles", "building", "wall", "roof", "door",
	"floor", "school", "classroom", "desk", "chair", "table", "bookcase",
	"eyebrow", "eyes", "teeth", "tongue", "animation", "tree", "cherry", "blossom",
	"nature", "bush", "flower", "foliage", "plant", "vegetation", "rock", "grass",
	"shrine", "torii", "temple", "pagoda", "dojo", "house", "town", "city",
	"street", "vehicle", "car", "bus", "train", "boat", "ship", "prop",
	"weapon", "sword", "asset", "environment", "landscape", "architecture", "map",
	"hair", "beard", "eyelash", "shoe", "glove", "accessory"]

const BODY_HINTS = ["fullbody", "full_body", "character", "student", "player",
	"avatar", "humanoid", "npc", "anime", "rigged", "mage", "girl", "boy",
	"female", "male", "woman", "man", "person", "human"]

static func list_models(dir_path = "res://models", exts = ["glb", "gltf"]):
	var out = []
	var d = Directory.new()
	if d.open(dir_path) != OK:
		return out
	d.list_dir_begin(true, true)
	var f = d.get_next()
	while f != "":
		if d.current_is_dir():
			for p in list_models(dir_path.plus_file(f), exts):
				if not out.has(p):
					out.append(p)
		else:
			var fname = f
			if fname.ends_with(".import"):
				fname = fname.substr(0, fname.length() - 7)
			var low = fname.to_lower()
			for e in exts:
				if low.ends_with("." + e):
					var path = dir_path.plus_file(fname)
					if not out.has(path):
						out.append(path)
					break
		f = d.get_next()
	d.list_dir_end()
	out.sort()
	return out

static func _contains_any(value, words):
	var low = value.to_lower()
	for word in words:
		if low.find(word) != -1:
			return true
	return false

static func _character_score(path):
	var filename = path.get_file().get_basename().to_lower()
	if _contains_any(filename, NOT_CHARACTER):
		return -1
	var score = 0
	for word in BODY_HINTS:
		if filename.find(word) != -1:
			score += 10
	var folder_text = path.get_base_dir().to_lower()
	if _contains_any(folder_text, ["characters", "personajes", "avatars", "anime"]):
		score += 5
	if filename.find("fullbody") != -1 or filename.find("full_body") != -1:
		score += 30
	if filename.find("rigged") != -1:
		score += 15
	return score

static func characters():
	var ranked = []
	for path in list_models():
		var score = _character_score(path)
		if score >= 0:
			ranked.append({"path": path, "score": score})
	for i in range(ranked.size()):
		for j in range(i + 1, ranked.size()):
			if int(ranked[j].score) > int(ranked[i].score):
				var swap = ranked[i]
				ranked[i] = ranked[j]
				ranked[j] = swap
	var result = []
	for item in ranked:
		result.append(item.path)
	return result

static func best_character():
	var found = characters()
	return found[0] if found.size() > 0 else ""

static func find_model(keywords, exts = ["glb", "gltf"]):
	var all = list_models("res://models", exts)
	for keyword in keywords:
		for path in all:
			if path.get_file().to_lower().find(keyword) != -1:
				return path
	return ""
