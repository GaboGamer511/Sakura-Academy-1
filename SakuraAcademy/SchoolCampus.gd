tool
extends Spatial

var mat_cache = {}
var build_parent = null

func _ready():
	# El campus se genera tanto en el editor como al ejecutar el juego.
	# Los nodos generados son una vista previa: se regeneran al abrir Main.tscn.
	if has_node("_CampusPreviewGenerated"):
		build_parent = get_node("_CampusPreviewGenerated")
		for old_child in build_parent.get_children():
			old_child.free()
	else:
		build_parent = Spatial.new()
		build_parent.name = "_CampusPreviewGenerated"
		add_child(build_parent)
	print("Sakura Academy: construyendo campus")
	var imported_school = _instance_real_school_kit()
	if imported_school:
		# Con el kit GLB instalado no se dibujan edificios ni árboles de cubos/esferas.
		# Se conserva únicamente una superficie base física para caminar.
		_build_imported_campus_ground()
		# Mantener el suelo de respaldo visible evita una pantalla vacía
		# si el GLB carga pero sus materiales o mallas no se dibujan en GLES2.
		var fallback_mesh = get_parent().get_node_or_null("FallbackGround")
		if fallback_mesh:
			fallback_mesh.visible = true
	else:
		# Campus de respaldo solo para la primera apertura sin recursos descargados.
		_build_ground()
		_build_main_school()
		_build_wings()
		_build_courtyard()
		_build_gardens()
		_build_sports_area()
		_build_furniture()
	if Engine.editor_hint:
		_assign_preview_owner(build_parent, get_tree().edited_scene_root)
	print("Sakura Academy: campus listo")


func _build_imported_campus_ground():
	var body = StaticBody.new()
	body.name = "ImportedCampusWalkableBase"
	var collision = CollisionShape.new()
	var shape = BoxShape.new()
	shape.extents = Vector3(65.0, 0.2, 65.0)
	collision.shape = shape
	collision.translation = Vector3(0.0, -0.2, 0.0)
	body.add_child(collision)
	build_parent.add_child(body)


func _instance_real_school_kit():
	var model_path = "res://models/japanese_school_campus.glb"
	if not ResourceLoader.exists(model_path):
		return false
	var packed = load(model_path)
	if not (packed is PackedScene):
		push_warning("El GLB del campus existe pero Godot todavía no lo importó como PackedScene.")
		return false
	var imported = packed.instance()
	imported.name = "JapaneseSchoolAndCityStreet_REAL_3D"
	build_parent.add_child(imported)
	if _count_mesh_instances(imported) == 0:
		push_warning("El GLB se importó, pero no contiene MeshInstance visibles. Se usará el campus de respaldo.")
		imported.free()
		return false
	if Engine.editor_hint:
		_assign_preview_owner(imported, get_tree().edited_scene_root)
	print("Sakura Academy: campus modular GLB real cargado")
	return true


func _count_mesh_instances(node):
	var count = 1 if node is MeshInstance and node.mesh != null else 0
	for child in node.get_children():
		count += _count_mesh_instances(child)
	return count

func _mat(color):
	var key = color.to_html()
	if mat_cache.has(key): return mat_cache[key]
	var m = SpatialMaterial.new()
	m.albedo_color = color
	m.roughness = 0.86
	mat_cache[key] = m
	return m

func _box(label, pos, size, color, solid=false):
	var mesh = CubeMesh.new()
	mesh.size = size
	var mi = MeshInstance.new()
	mi.name = label
	mi.mesh = mesh
	mi.translation = pos
	mi.material_override = _mat(color)
	build_parent.add_child(mi)
	if solid:
		var body = StaticBody.new()
		body.name = label + "Collision"
		body.translation = pos
		var shape = CollisionShape.new()
		var box = BoxShape.new()
		box.extents = size * 0.5
		shape.shape = box
		body.add_child(shape)
		build_parent.add_child(body)
	return mi

func _build_ground():
	_box("Campus lawn", Vector3(0,-0.18,0), Vector3(100,0.3,100), Color(0.34,0.48,0.34), true)
	_box("Central stone path", Vector3(0,0.005,2), Vector3(7,0.035,43), Color(0.73,0.70,0.66))
	_box("Cross path", Vector3(0,0.012,-9), Vector3(48,0.04,5), Color(0.73,0.70,0.66))
	_box("Entrance path", Vector3(0,0.02,27), Vector3(12,0.06,14), Color(0.65,0.62,0.59))
	_box("Front boundary", Vector3(0,1.1,35), Vector3(72,2.2,0.35), Color(0.22,0.27,0.34), true)

func _build_main_school():
	_room("Sakura Main Building", Vector3(0,0,-23), Vector3(31,5,10), Color(0.83,0.82,0.78), 4.2)
	_box("Main roof trim", Vector3(0,5.32,-23), Vector3(32,0.35,10.8), Color(0.16,0.22,0.34))
	_box("Entrance canopy", Vector3(0,3.5,-17.55), Vector3(9,0.35,2.5), Color(0.72,0.56,0.39))
	_box("School emblem panel", Vector3(0,4.25,-17.72), Vector3(3.2,1.0,0.18), Color(0.22,0.29,0.43))
	_box("Main doors left", Vector3(-0.92,1.25,-17.86), Vector3(1.75,2.5,0.12), Color(0.34,0.24,0.19))
	_box("Main doors right", Vector3(0.92,1.25,-17.86), Vector3(1.75,2.5,0.12), Color(0.34,0.24,0.19))
	for x in [-12,-8,-4,4,8,12]:
		_box("Front window", Vector3(x,3.0,-17.84), Vector3(2.0,1.8,0.10), Color(0.40,0.63,0.75))
		_box("Upper window", Vector3(x,4.4,-17.84), Vector3(2.0,0.75,0.10), Color(0.48,0.68,0.78))
	# Classroom desks and boards.
	for x in [-11,-7,-3,3,7,11]:
		for z in [-25.5,-21.5]:
			_desk(Vector3(x,0,z))
	_box("Main hall blackboard", Vector3(0,1.8,-27.55), Vector3(7,1.5,0.12), Color(0.10,0.22,0.20))

func _room(label, center, size, wall_color, door_width=3.0):
	var half_x = size.x * 0.5
	var half_z = size.z * 0.5
	var h = size.y
	_box(label + " floor", center + Vector3(0,-0.015,0), Vector3(size.x,0.03,size.z), Color(0.66,0.62,0.56), true)
	_box(label + " roof", center + Vector3(0,h+0.12,0), Vector3(size.x+0.4,0.24,size.z+0.4), Color(0.18,0.25,0.38), true)
	_box(label + " west wall", center + Vector3(-half_x+0.12,h*0.5,0), Vector3(0.24,h,size.z), wall_color, true)
	_box(label + " east wall", center + Vector3(half_x-0.12,h*0.5,0), Vector3(0.24,h,size.z), wall_color, true)
	_box(label + " back wall", center + Vector3(0,h*0.5,-half_z+0.12), Vector3(size.x,h,0.24), wall_color, true)
	var segment = (size.x-door_width)*0.5
	_box(label + " front left", center + Vector3(-(door_width+segment)*0.5,h*0.5,half_z-0.12), Vector3(segment,h,0.24), wall_color, true)
	_box(label + " front right", center + Vector3((door_width+segment)*0.5,h*0.5,half_z-0.12), Vector3(segment,h,0.24), wall_color, true)
	_box(label + " front lintel", center + Vector3(0,h-0.45,half_z-0.12), Vector3(door_width,0.9,0.24), wall_color, true)
	_box(label + " entrance jamb left", center + Vector3(-door_width*0.5,1.3,half_z+0.03), Vector3(0.12,2.6,0.12), Color(0.31,0.38,0.48))
	_box(label + " entrance jamb right", center + Vector3(door_width*0.5,1.3,half_z+0.03), Vector3(0.12,2.6,0.12), Color(0.31,0.38,0.48))
	_box(label + " entrance header", center + Vector3(0,2.62,half_z+0.03), Vector3(door_width,0.12,0.12), Color(0.31,0.38,0.48))

func _build_wings():
	_room("Library", Vector3(-22,0,13), Vector3(11,3.4,10), Color(0.76,0.78,0.82), 2.8)
	_room("Cafeteria", Vector3(22,0,13), Vector3(11,3.4,10), Color(0.84,0.78,0.70), 2.8)
	_room("Gymnasium", Vector3(0,0,-34), Vector3(19,4.6,7), Color(0.72,0.76,0.80), 3.5)
	_room("Club building", Vector3(0,0,18), Vector3(12,3.6,7), Color(0.80,0.77,0.83), 3.0)
	# Furniture silhouettes inside each accessible building.
	for x in [-24,-21,-18]:
		_box("Library bookshelf", Vector3(x,1.25,12), Vector3(0.45,2.5,3.5), Color(0.38,0.27,0.20), true)
	for x in [19,22,25]:
		_desk(Vector3(x,0,12))
		_desk(Vector3(x,0,15))
	for x in [-3.5,0,3.5]:
		_desk(Vector3(x,0,18))
	_box("Gym court marking", Vector3(0,0.03,-34), Vector3(12,0.035,0.10), Color(0.93,0.93,0.88))

func _desk(p):
	_box("Student desk top", p + Vector3(0,0.78,0), Vector3(1.25,0.12,0.75), Color(0.54,0.38,0.27))
	for dx in [-0.48,0.48]:
		for dz in [-0.25,0.25]:
			_box("Desk leg", p + Vector3(dx,0.38,dz), Vector3(0.08,0.76,0.08), Color(0.28,0.25,0.23), true)

func _build_courtyard():
	_box("Fountain base", Vector3(0,0.28,4), Vector3(4.5,0.55,4.5), Color(0.60,0.65,0.70))
	_box("Fountain water", Vector3(0,0.59,4), Vector3(3.9,0.08,3.9), Color(0.24,0.61,0.76))
	_box("Fountain pillar", Vector3(0,1.05,4), Vector3(0.65,0.9,0.65), Color(0.78,0.80,0.84))
	_box("School sign", Vector3(0,1.3,29), Vector3(8,2.6,0.35), Color(0.18,0.24,0.38), true)
	_box("Sakura lettering panel", Vector3(0,1.5,28.78), Vector3(5.8,0.65,0.08), Color(0.91,0.75,0.82))
	var emblem_mesh = QuadMesh.new()
	emblem_mesh.size = Vector2(1.45,1.45)
	var emblem = MeshInstance.new()
	emblem.name = "Sakura Academy Emblem"
	emblem.mesh = emblem_mesh
	emblem.translation = Vector3(0,1.45,28.72)
	var emblem_material = SpatialMaterial.new()
	emblem_material.albedo_texture = load("res://sakura_emblem.png")
	emblem_material.flags_unshaded = true
	emblem_material.flags_transparent = true
	emblem.material_override = emblem_material
	build_parent.add_child(emblem)

func _build_gardens():
	for x in [-29,-25,-15,-10,10,15,25,29]:
		for z in [-14,-5,6,17,25]:
			_tree(Vector3(x,0,z))
	for x in [-8,8]:
		for z in [-9,13]:
			_tree(Vector3(x,0,z))

func _tree(p):
	_box("Cherry trunk", p + Vector3(0,1.2,0), Vector3(0.35,2.4,0.35), Color(0.34,0.23,0.18), true)
	var crown = SphereMesh.new()
	crown.radius = 1.25
	crown.height = 2.5
	var foliage = MeshInstance.new()
	foliage.mesh = crown
	foliage.translation = p + Vector3(0,3.0,0)
	foliage.scale = Vector3(1.3,1.0,1.3)
	foliage.material_override = _mat(Color(0.82,0.52,0.68))
	build_parent.add_child(foliage)

func _build_sports_area():
	_box("Sports court", Vector3(0,0.015,-44), Vector3(25,0.04,10), Color(0.35,0.49,0.57))
	for x in [-12,12]:
		_box("Court line", Vector3(x,0.05,-44), Vector3(0.12,0.04,10), Color(0.93,0.93,0.88))
	_box("Goal left", Vector3(-8,1,-44), Vector3(0.18,2,2.8), Color(0.90,0.90,0.86))
	_box("Goal right", Vector3(8,1,-44), Vector3(0.18,2,2.8), Color(0.90,0.90,0.86))

func _build_furniture():
	for p in [Vector3(-7,0,7),Vector3(7,0,7),Vector3(-13,0,18),Vector3(13,0,18)]:
		_bench(p)
	for x in [-5,5]:
		_box("Lamp post", Vector3(x,2.0,22), Vector3(0.12,4,0.12), Color(0.18,0.20,0.23))
		_box("Lamp", Vector3(x,4.1,22), Vector3(0.7,0.25,0.7), Color(0.96,0.87,0.65))

func _bench(p):
	_box("Bench seat", p + Vector3(0,0.55,0), Vector3(2.0,0.13,0.55), Color(0.40,0.25,0.16))
	_box("Bench back", p + Vector3(0,0.95,0.22), Vector3(2.0,0.65,0.13), Color(0.40,0.25,0.16))


func _assign_preview_owner(node, scene_owner):
	if node == null or scene_owner == null:
		return
	node.owner = scene_owner
	for child in node.get_children():
		_assign_preview_owner(child, scene_owner)
