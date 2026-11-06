extends Reference
# Ensambla el mundo exclusivamente con escenas 3D importadas.
# Este archivo NO crea edificios, árboles, mobiliario ni decoración con primitivas.
# Las colisiones de respaldo son invisibles y solo evitan que el jugador caiga si
# todavía no se han instalado los paquetes artísticos finales.

const Toon = preload("res://Toon.gd")
const Models = preload("res://Models.gd")

const WORLD_ASSETS = [
	{
		"name": "SakuraAcademyCampus",
		"keywords": ["school_campus", "academy", "campus", "school"],
		"position": Vector3(0, 0, -12),
		"yaw": 0.0,
		"scale": Vector3(1, 1, 1),
		"main": true
	},
	{
		"name": "JapaneseTownDistrict",
		"keywords": ["urban_district", "japanese_town", "city_district", "shopping_street"],
		"position": Vector3(-92, 0, -30),
		"yaw": 0.0,
		"scale": Vector3(1, 1, 1),
		"main": false
	},
	{
		"name": "ShintoShrine",
		"keywords": ["shinto_shrine", "shrine", "torii"],
		"position": Vector3(92, 0, -32),
		"yaw": 0.0,
		"scale": Vector3(1, 1, 1),
		"main": false
	},
	{
		"name": "BuddhistTemple",
		"keywords": ["buddhist_temple", "temple", "pagoda"],
		"position": Vector3(110, 0, 65),
		"yaw": 0.0,
		"scale": Vector3(1, 1, 1),
		"main": false
	},
	{
		"name": "CoastAndHarbor",
		"keywords": ["coast", "beach", "harbor", "pier"],
		"position": Vector3(0, 0, 120),
		"yaw": 0.0,
		"scale": Vector3(1, 1, 1),
		"main": false
	},
	{
		"name": "SakuraForestAndLake",
		"keywords": ["sakura_forest", "cherry_grove", "blossom_forest", "cherry_forest"],
		"position": Vector3(-105, 0, 76),
		"yaw": 0.0,
		"scale": Vector3(1, 1, 1),
		"main": false
	},
	{
		"name": "KendoDojo",
		"keywords": ["kendo_dojo", "martial_arts_dojo", "dojo"],
		"position": Vector3(26, 0, 4),
		"yaw": 0.0,
		"scale": Vector3(1, 1, 1),
		"main": false
	}
]


static func build_all(parent):
	_add_invisible_safety_floor(parent)
	var loaded_paths = []
	var loaded_count = 0

	for definition in WORLD_ASSETS:
		var model_path = Models.find_model(definition.keywords)
		if model_path == "" or loaded_paths.has(model_path):
			continue
		if not ResourceLoader.exists(model_path):
			continue

		var model_resource = load(model_path)
		var instance = _make_instance(model_resource)
		if instance == null:
			push_warning("El recurso 3D no pudo instanciarse: " + model_path)
			continue

		instance.name = definition.name
		instance.translation = definition.position
		instance.rotation_degrees.y = definition.yaw
		instance.scale = definition.scale
		parent.add_child(instance)

		# Se armonizan materiales importados sin reemplazar sus mapas PBR ni su geometría.
		Toon.apply(instance, 0.0)
		_add_mesh_collisions(instance)

		loaded_paths.append(model_path)
		loaded_count += 1
		print("Sakura Academy: escena importada: ", definition.name, " <- ", model_path)

	if loaded_count == 0:
		print("Sakura Academy: faltan los escenarios 3D en res://models/. El mundo se mantiene sin sustitutos geométricos.")
	return loaded_count


static func _make_instance(resource):
	if resource == null:
		return null
	if resource is PackedScene:
		return resource.instance()
	if resource is Mesh:
		var mesh_instance = MeshInstance.new()
		mesh_instance.mesh = resource
		return mesh_instance
	return null


static func _add_mesh_collisions(node):
	if node is MeshInstance and node.mesh != null:
		# Colisión trimesh basada en la malla real importada, no en geometría visual nueva.
		node.create_trimesh_collision()
	for child in node.get_children():
		_add_mesh_collisions(child)


static func _add_invisible_safety_floor(parent):
	var body = StaticBody.new()
	body.name = "InvisibleWorldSafetyFloor"
	var collision = CollisionShape.new()
	var shape = BoxShape.new()
	shape.extents = Vector3(165, 1, 165)
	collision.shape = shape
	collision.translation = Vector3(0, -1, 0)
	body.add_child(collision)
	parent.add_child(body)
