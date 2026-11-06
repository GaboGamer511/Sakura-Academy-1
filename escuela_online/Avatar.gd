extends Spatial
# Cuerpo visual reutilizable (jugadores, NPCs, rival): usa un modelo .glb/.gltf con estilo anime
# o, si no hay, una cápsula de colores. Incluye animación procedural (rebote al caminar,
# estocada al atacar, caída al morir) y destello rojo al recibir daño.

const Toon = preload("res://Toon.gd")

const MODEL_SCALE = 1.0
const MODEL_YAW_OFFSET = 0.0     # grados; 180 si tu personaje mira hacia atrás
const OUTLINE_THICKNESS = 0.012

var has_sword = false
var extra_scale = 1.0
var tint = Color(0.4, 0.6, 0.95)
var tint_strength = 0.0   # 0 = colores originales del modelo; 0.5 = mezcla con el color

var body                 # Spatial interno que se anima
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
	var ok = false
	if model_path != "" and ResourceLoader.exists(model_path):
		ok = _load_model(model_path)
	if not ok:
		_build_fallback()
	_collect_materials(body)
	if ok and tint_strength > 0.0:
		var c = Color(1, 1, 1).linear_interpolate(tint, tint_strength)
		for m in materials:
			m.set_shader_param("albedo", c)


func _load_model(path):
	var scene = load(path)
	if scene == null:
		return false
	var inst = scene.instance()
	inst.scale = Vector3(MODEL_SCALE, MODEL_SCALE, MODEL_SCALE)
	inst.rotation_degrees.y = MODEL_YAW_OFFSET
	body.add_child(inst)
	Toon.apply(inst, OUTLINE_THICKNESS)
	anim_player = _find_anim_player(inst)
	if anim_player:
		anim_idle = _find_anim("idle", "")
		anim_run = _find_anim("run", "walk")
		anim_attack = _find_anim("attack", "")
		for a in [anim_idle, anim_run]:
			if a != "":
				anim_player.get_animation(a).loop = true
		if anim_idle != "":
			anim_player.play(anim_idle)
	return true


func _find_anim_player(node):
	if node is AnimationPlayer:
		return node
	for c in node.get_children():
		var r = _find_anim_player(c)
		if r:
			return r
	return null


func _find_anim(key, alt):
	for k in [key, alt]:
		if k == "":
			continue
		for n in anim_player.get_animation_list():
			if n.to_lower().find(k) != -1:
				return n
	return ""


func _build_fallback():
	var src = SpatialMaterial.new()
	src.albedo_color = tint
	var mi = MeshInstance.new()
	var cm = CapsuleMesh.new()
	cm.radius = 0.4
	cm.mid_height = 1.0
	mi.mesh = cm
	mi.translation = Vector3(0, 0.9, 0)
	mi.material_override = Toon.make_material(src, OUTLINE_THICKNESS)
	body.add_child(mi)

	var nose = MeshInstance.new()
	var nm = CubeMesh.new()
	nm.size = Vector3(0.2, 0.2, 0.3)
	nose.mesh = nm
	nose.translation = Vector3(0, 1.5, 0.4)
	var nsrc = SpatialMaterial.new()
	nsrc.albedo_color = Color(1, 0.9, 0.8)
	nose.material_override = Toon.make_material(nsrc, 0.0)
	body.add_child(nose)

	if has_sword:
		sword_pivot = Spatial.new()
		sword_pivot.translation = Vector3(0.55, 1.1, 0.2)
		sword_pivot.rotation_degrees = Vector3(-60, 0, 0)
		body.add_child(sword_pivot)
		var sword = MeshInstance.new()
		var sm = CubeMesh.new()
		sm.size = Vector3(0.08, 0.08, 1.1)
		sword.mesh = sm
		sword.translation = Vector3(0, 0, 0.55)
		var ssrc = SpatialMaterial.new()
		ssrc.albedo_color = Color(0.8, 0.65, 0.4)
		sword.material_override = Toon.make_material(ssrc, 0.0)
		sword_pivot.add_child(sword)


func _collect_materials(node):
	if node is MeshInstance:
		if node.material_override is ShaderMaterial:
			materials.append(node.material_override)
		if node.mesh:
			for i in range(node.mesh.get_surface_count()):
				var m = node.get_surface_material(i)
				if m is ShaderMaterial:
					materials.append(m)
	for c in node.get_children():
		_collect_materials(c)


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
	var anim_driven = anim_player != null and anim_run != ""

	if moving != _last_moving:
		_last_moving = moving
		if anim_player and not (attack_t >= 0.0 and anim_attack != ""):
			var a = anim_run if moving else anim_idle
			if a != "":
				anim_player.play(a, 0.15)

	if moving and not anim_driven and not dead:
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
	var lie = 1.45 if dead else 0.0
	body.rotation.z = lerp(body.rotation.z, lie, min(1.0, delta * 8.0))

	if flash_t > 0.0:
		flash_t = max(0.0, flash_t - delta)
	var f = clamp(flash_t / 0.25, 0.0, 1.0)
	for m in materials:
		m.set_shader_param("flash", f)
