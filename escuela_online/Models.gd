extends Reference
# Busca modelos dentro de res://models sin importar cómo se llamen ni en qué subcarpeta
# hayan quedado. Así no hay que renombrar nada a mano.

# Textos que indican que un archivo NO es un personaje (muebles, edificios, piezas sueltas)
const NOT_CHARACTER = ["kenney", "furniture", "muebles", "building", "wall", "roof", "door",
	"floor", "school", "classroom", "desk", "chair", "table", "bookcase", "hair", "beard",
	"eyebrow", "eyes", "teeth", "tongue", "animation", "tree", "cherry", "blossom", "nature", "bush", "flower", "foliage", "plant", "vegetation", "rock", "grass"]

# Textos que sugieren que SÍ es un cuerpo completo (se ponen primero en la lista)
const BODY_HINTS = ["fullbody", "body", "character", "student", "male", "female", "player"]


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
					var p2 = dir_path.plus_file(fname)
					if not out.has(p2):
						out.append(p2)
					break
		f = d.get_next()
	d.list_dir_end()
	out.sort()
	return out


static func _contains_any(text, words):
	var low = text.to_lower()
	for w in words:
		if low.find(w) != -1:
			return true
	return false


# Lista de modelos que parecen personajes (cuerpos completos primero).
static func characters():
	var first = []
	var rest = []
	for p in list_models():
		if _contains_any(p, NOT_CHARACTER):
			continue
		if _contains_any(p.get_file(), BODY_HINTS):
			first.append(p)
		else:
			rest.append(p)
	return first + rest


# Primer modelo (de las extensiones dadas) cuyo nombre de archivo contiene alguna palabra clave.
static func find_model(keywords, exts = ["glb", "gltf"]):
	var all = list_models("res://models", exts)
	for k in keywords:
		for p in all:
			if p.get_file().to_lower().find(k) != -1:
				return p
	return ""
