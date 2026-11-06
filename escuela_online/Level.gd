extends Reference
# Geometría del escenario: escuela, dojo del club de kendo y arena del rival.
# Si existe un modelo de escuela en res://models (nombre con "school"/"classroom"), se usa
# en lugar de la escuela de cajas.

const Toon = preload("res://Toon.gd")
const Models = preload("res://Models.gd")

const SCHOOL_KEYWORDS = ["school", "classroom"]
const SCHOOL_SCALE = 1.0

# Decoración opcional (si hay un modelo con ese nombre en res://models, reemplaza la caja)
const DESK_KEYWORDS = ["desk"]
const DESK_EXTS = ["glb", "gltf", "obj", "dae"]
const DESK_SCALE = 1.0


static func box(parent, pos, size, color, solid = true):
	var body = StaticBody.new()
	body.translation = pos
	if solid:
		var shape = CollisionShape.new()
		var bs = BoxShape.new()
		bs.extents = size / 2.0
		shape.shape = bs
		body.add_child(shape)
	var mi = MeshInstance.new()
	var cm = CubeMesh.new()
	cm.size = size
	mi.mesh = cm
	var mat = SpatialMaterial.new()
	mat.albedo_color = color
	mi.material_override = mat
	body.add_child(mi)
	parent.add_child(body)
	return body


static func build_all(parent):
	var school_path = Models.find_model(SCHOOL_KEYWORDS)
	if school_path != "" and ResourceLoader.exists(school_path):
		_load_school_model(parent, school_path)
	else:
		_build_school(parent)
	_build_dojo(parent)
	_build_arena(parent)


static func _load_school_model(parent, path):
	var school = load(path).instance()
	school.scale = Vector3(SCHOOL_SCALE, SCHOOL_SCALE, SCHOOL_SCALE)
	parent.add_child(school)
	Toon.apply(school, 0.0)
	_add_collisions(school)
	# Suelo de seguridad por si el modelo no trae piso
	var fb = StaticBody.new()
	fb.translation = Vector3(0, -1.0, 0)
	var shape = CollisionShape.new()
	var bs = BoxShape.new()
	bs.extents = Vector3(150, 1, 150)
	shape.shape = bs
	fb.add_child(shape)
	parent.add_child(fb)


# Los .glb/.gltf/.dae se cargan como escena; un .obj se carga como malla suelta.
static func _make_instance(res):
	if res is PackedScene:
		return res.instance()
	var mi = MeshInstance.new()
	mi.mesh = res
	return mi


static func _add_collisions(node):
	if node is MeshInstance and node.mesh:
		node.create_trimesh_collision()
	for c in node.get_children():
		_add_collisions(c)


static func _build_school(parent):
	box(parent, Vector3(0, -0.5, 0), Vector3(120, 1, 120), Color(0.45, 0.62, 0.38))         # suelo
	box(parent, Vector3(0, 0.02, 8), Vector3(6, 0.04, 30), Color(0.75, 0.72, 0.65), false)  # camino

	var wall = Color(0.93, 0.9, 0.82)
	var roof = Color(0.55, 0.25, 0.22)
	box(parent, Vector3(0, 3, -20), Vector3(30, 6, 0.6), wall)
	box(parent, Vector3(-15, 3, -10), Vector3(0.6, 6, 20), wall)
	box(parent, Vector3(15, 3, -10), Vector3(0.6, 6, 20), wall)
	box(parent, Vector3(-9.5, 3, 0), Vector3(11, 6, 0.6), wall)
	box(parent, Vector3(9.5, 3, 0), Vector3(11, 6, 0.6), wall)
	box(parent, Vector3(0, 5, 0), Vector3(8, 2, 0.6), wall)           # dintel de la puerta
	box(parent, Vector3(0, 6.3, -10), Vector3(31, 0.6, 21), roof)
	box(parent, Vector3(-5, 3, -12), Vector3(0.4, 6, 16), wall)       # paredes de aulas
	box(parent, Vector3(5, 3, -12), Vector3(0.4, 6, 16), wall)

	# Pizarras y escritorio del profesor
	box(parent, Vector3(-14.6, 2.2, -12), Vector3(0.1, 1.6, 5), Color(0.12, 0.3, 0.2), false)
	box(parent, Vector3(14.6, 2.2, -12), Vector3(0.1, 1.6, 5), Color(0.12, 0.3, 0.2), false)
	box(parent, Vector3(-12.8, 0.5, -12), Vector3(1.4, 1.0, 2.6), Color(0.45, 0.3, 0.18))
	box(parent, Vector3(12.8, 0.5, -12), Vector3(1.4, 1.0, 2.6), Color(0.45, 0.3, 0.18))

	# Pupitres (con modelo opcional)
	var desk_path = Models.find_model(DESK_KEYWORDS, DESK_EXTS)
	var desk_scene = null
	if desk_path != "" and ResourceLoader.exists(desk_path):
		desk_scene = load(desk_path)
	for x in [-10.5, -8, 8, 10.5]:
		for z in [-7, -10, -13, -16]:
			var d = box(parent, Vector3(x, 0.45, z), Vector3(1.2, 0.9, 0.8), Color(0.6, 0.42, 0.25))
			if desk_scene:
				d.get_child(1).visible = false          # oculta la caja, deja la colisión
				var m = _make_instance(desk_scene)
				m.scale = Vector3(DESK_SCALE, DESK_SCALE, DESK_SCALE)
				m.translation = Vector3(0, -0.45, 0)
				d.add_child(m)
				Toon.apply(m, 0.0)

	# Bancas del patio
	box(parent, Vector3(-10, 0.4, 14), Vector3(3, 0.8, 0.8), Color(0.5, 0.35, 0.2))
	box(parent, Vector3(10, 0.4, 14), Vector3(3, 0.8, 0.8), Color(0.5, 0.35, 0.2))
	# Árboles sencillos
	for p in [Vector3(-20, 0, 14), Vector3(20, 0, -14), Vector3(-22, 0, -8), Vector3(8, 0, 22)]:
		box(parent, p + Vector3(0, 1.5, 0), Vector3(0.6, 3, 0.6), Color(0.4, 0.28, 0.18))
		box(parent, p + Vector3(0, 3.8, 0), Vector3(3, 2.6, 3), Color(0.3, 0.55, 0.3), false)
	# Reja del perímetro
	for i in range(-5, 6):
		box(parent, Vector3(i * 11, 0.9, 58), Vector3(1, 1.8, 0.3), Color(0.35, 0.35, 0.4))
		box(parent, Vector3(i * 11, 0.9, -58), Vector3(1, 1.8, 0.3), Color(0.35, 0.35, 0.4))
		box(parent, Vector3(58, 0.9, i * 11), Vector3(0.3, 1.8, 1), Color(0.35, 0.35, 0.4))
		box(parent, Vector3(-58, 0.9, i * 11), Vector3(0.3, 1.8, 1), Color(0.35, 0.35, 0.4))


# Dojo del club de kendo: x 18..34, z -4..12
static func _build_dojo(parent):
	box(parent, Vector3(26, 0.05, 4), Vector3(16, 0.1, 16), Color(0.7, 0.5, 0.3), false)
	var wood = Color(0.45, 0.28, 0.16)
	box(parent, Vector3(26, 0.6, 12.2), Vector3(16, 1.2, 0.3), wood)
	box(parent, Vector3(26, 0.6, -4.2), Vector3(16, 1.2, 0.3), wood)
	box(parent, Vector3(34.2, 0.6, 4), Vector3(0.3, 1.2, 16), wood)
	box(parent, Vector3(17.8, 0.6, -1.5), Vector3(0.3, 1.2, 5), wood)    # entrada por el lado oeste
	box(parent, Vector3(17.8, 0.6, 9.5), Vector3(0.3, 1.2, 5), wood)
	# Cartel del dojo
	box(parent, Vector3(26, 2.2, -4.2), Vector3(5, 1.0, 0.2), Color(0.75, 0.15, 0.15), false)


# Arena de piedra del rival: x -36..-24, z 0..16
static func _build_arena(parent):
	box(parent, Vector3(-30, 0.05, 8), Vector3(12, 0.1, 16), Color(0.5, 0.5, 0.55), false)
	var stone = Color(0.4, 0.4, 0.45)
	box(parent, Vector3(-30, 0.7, 16.2), Vector3(12, 1.4, 0.4), stone)
	box(parent, Vector3(-30, 0.7, -0.2), Vector3(12, 1.4, 0.4), stone)
	box(parent, Vector3(-36.2, 0.7, 8), Vector3(0.4, 1.4, 16), stone)
	box(parent, Vector3(-23.8, 0.7, 2.5), Vector3(0.4, 1.4, 5), stone)    # entrada por el lado este
	box(parent, Vector3(-23.8, 0.7, 13.5), Vector3(0.4, 1.4, 5), stone)
