extends Spatial
# Avatar reutilizable: carga modelos 3D riggeados y reproduce clips importados.
# La cápsula es únicamente un respaldo temporal cuando todavía no hay modelo instalado.

const Toon = preload("res://Toon.gd")
const Models = preload("res://Models.gd")
const MODEL_SCALE = 1.0
const MODEL_YAW_OFFSET = 0.0
const OUTLINE_THICKNESS = 0.012

var has_sword = false
var extra_scale = 1.0
var tint = Color(0.4, 0.6, 0.95)
var tint_strength = 0.0
var body
var sword_pivot
var anim_player
var anim_idle = ""
var anim_run = ""
var anim_attack = ""
var materials = []
var moving = false
var dead = false
var attack_t = -1.0
var flash_t = 0.0
var t = 0.0
var _last_moving = false

func setup(model_path, color):
	tint = color
	body = Spatial.new()
	body.scale = Vector3(extra_scale, extra_scale, extra_scale)
	add_child(body)
	var selected_path = model_path
	if selected_path == "" or not ResourceLoader.exists(selected_path):
		selected_path = Models.best_character()
	var ok = false
	if selected_path != "" and ResourceLoader.exists(selected_path):
		ok = _load_model(selected_path)
	if not ok:
		push_warning("Sakura Academy: no se encontró un personaje GLB/GLTF válido. Instala un modelo riggeado en models/.")
		_build_fallback()
	_collect_materials(body)
	if ok and tint_strength > 0.0:
		var c = Color(1, 1, 1).linear_interpolate(tint, tint_strength)
		for material in materials:
			material.set_shader_param("albedo", c)

func _load_model(path):
	var resource = load(path)
	if resource == null or not (resource is PackedScene):
		push_warning("Sakura Academy: el archivo de personaje no es una escena importable: " + path)
		return false
	var instance = resource.instance()
	instance.scale = Vector3(MODEL_SCALE, MODEL_SCALE, MODEL_SCALE)
	instance.rotation_degrees.y = MODEL_YAW_OFFSET
	body.add_child(instance)
	Toon.apply(instance, OUTLINE_THICKNESS)
	anim_player = _find_anim_player(instance)
	if anim_player:
		anim_idle = _find_anim(["idle", "stand", "breath"])
		anim_run = _find_anim(["run", "walk", "locomotion"])
		anim_attack = _find_anim(["attack", "slash", "hit", "cast"])
		for animation_name in [anim_idle, anim_run]:
			if animation_name != "":
				anim_player.get_animation(animation_name).loop = true
		if anim_idle != "":
			anim_player.play(anim_idle)
	else:
		push_warning("Sakura Academy: el personaje se cargó, pero no contiene AnimationPlayer: " + path)
	return true

func _find_anim_player(node):
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found = _find_anim_player(child)
		if found:
			return found
	return null

func _find_anim(keywords):
	if anim_player == null:
		return ""
	var names = anim_player.get_animation_list()
	for keyword in keywords:
		for animation_name in names:
			if animation_name.to_lower().find(keyword) != -1:
				return animation_name
	return ""

func _build_fallback():
	var material = SpatialMaterial.new()
	material.albedo_color = tint
	var mesh_instance = MeshInstance.new()
	var capsule = CapsuleMesh.new()
	capsule.radius = 0.4
	capsule.mid_height = 1.0
	mesh_instance.mesh = capsule
	mesh_instance.translation = Vector3(0, 0.9, 0)
	mesh_instance.material_override = material
	body.add_child(mesh_instance)

func _collect_materials(node):
	if node is MeshInstance:
		if node.material_override is ShaderMaterial:
			materials.append(node.material_override)
		if node.mesh:
			for i in range(node.mesh.get_surface_count()):
				var material = node.get_surface_material(i)
				if material is ShaderMaterial:
					materials.append(material)
	for child in node.get_children():
		_collect_materials(child)

func flash():
	flash_t = 0.25

func play_attack():
	attack_t = 0.0
	if anim_player and anim_attack != "":
		anim_player.play(anim_attack, 0.1)

func _process(delta):
	t += delta
	var bob = 0.0
	var lean = 0.0
	var animation_driven = anim_player != null and anim_run != ""
	if moving != _last_moving:
		_last_moving = moving
		if anim_player and not (attack_t >= 0.0 and anim_attack != ""):
			var animation_name = anim_run if moving else anim_idle
			if animation_name != "":
				anim_player.play(animation_name, 0.15)
	if moving and not animation_driven and not dead:
		bob = abs(sin(t * 11.0)) * 0.07
		lean = 0.12
	if attack_t >= 0.0:
		attack_t += delta
		var k = attack_t / 0.35
		if k >= 1.0:
			attack_t = -1.0
			if anim_player and anim_idle != "":
				anim_player.play(anim_idle, 0.15)
		else:
			lean = 0.5 * sin(k * PI)
			if sword_pivot:
				sword_pivot.rotation_degrees.x = lerp(-80.0, 70.0, sin(k * PI * 0.5))
	elif sword_pivot:
		sword_pivot.rotation_degrees.x = -60.0
	body.translation.y = bob
	body.rotation.x = lerp(body.rotation.x, lean, min(1.0, delta * 15.0))
	body.rotation.z = lerp(body.rotation.z, 1.45 if dead else 0.0, min(1.0, delta * 8.0))
	if flash_t > 0.0:
		flash_t = max(0.0, flash_t - delta)
	var flash_value = clamp(flash_t / 0.25, 0.0, 1.0)
	for material in materials:
		material.set_shader_param("flash", flash_value)
