extends Spatial
# Mundo compartido: entorno con ciclo día/noche, escuela, NPCs, enemigos, zonas, libros
# y spawn de jugadores. El anfitrión (servidor) decide quién recibe daño.

const PlayerScript = preload("res://Player.gd")
const NPCScript = preload("res://NPC.gd")
const EnemyScript = preload("res://Enemy.gd")
const HUDScript = preload("res://HUD.gd")
const Level = preload("res://Level.gd")
const Models = preload("res://Models.gd")

const BOOK_SPOTS = [
	Vector3(-6, 0.7, 6), Vector3(9, 0.7, 13), Vector3(-12, 0.7, -2),
	Vector3(12, 0.7, -2), Vector3(0, 0.7, -16), Vector3(23, 0.7, 14)
]

var spawned = {}
var sun
var env
var aula_count = 0
var study_acc = 0.0
var study_ticks = 0
var books = []
var books_by_id = {}


func _ready():
	randomize()
	_build_environment()
	_build_light()
	var loaded_environment_count = Level.build_all(self)
	add_child(HUDScript.new())          # primero el HUD: los demás le avisan por grupo
	_spawn_npcs()
	_spawn_enemies()
	_build_zones()
	_spawn_books()

	GameClock.connect("new_day", self, "_on_new_day")
	Network.connect("player_list_changed", self, "_sync_players")
	Network.connect("peer_left", self, "_on_peer_left")
	_sync_players()

	var timer = Timer.new()
	timer.wait_time = 20.0
	timer.autostart = true
	timer.connect("timeout", Stats, "save_game")
	add_child(timer)

	if loaded_environment_count == 0:
		get_tree().call_group("hud", "toast", "Faltan los modelos 3D del mundo. Coloca los escenarios aprobados en models/.")
	else:
		get_tree().call_group("hud", "toast", "Preparatoria Sakura. Habla con la profesora Sato [E]")


# ---------------------------------------------------------------
# Jugadores
# ---------------------------------------------------------------
func _sync_players():
	for id in Network.players:
		if not spawned.has(id):
			_spawn_player(id)


func _spawn_player(id):
	var p = PlayerScript.new()
	p.name = str(id)                  # mismo nombre en todos los peers
	p.set_network_master(id)
	p.player_name = Network.players[id]
	p.player_id = id
	p.model_path = Network.models.get(id, "")
	p.translation = _spawn_position(id)
	add_child(p)
	spawned[id] = p


# El mismo ID obtiene el mismo punto en todos los peers.
func _spawn_position(id):
	var index = max(0, int(id) - 1)
	var column = index % 4
	var row = int(index / 4)
	return Vector3(-3.0 + column * 2.0, 1.5, 7.0 + row * 2.5)


func _on_peer_left(id):
	if spawned.has(id):
		spawned[id].queue_free()
		spawned.erase(id)


# ---------------------------------------------------------------
# Combate (solo el servidor decide el daño)
# ---------------------------------------------------------------
func _in_dojo(pos):
	return pos.x > 17.0 and pos.x < 35.0 and pos.z > -5.0 and pos.z < 13.0


func _in_cone(pos, fwd, target_pos):
	var to = target_pos - pos
	to.y = 0
	var d = to.length()
	return d < 3.0 and (d < 0.9 or fwd.dot(to.normalized()) > 0.25)


func server_hit(attacker_id, pos, yaw, dmg):
	dmg = clamp(dmg, 5.0, 60.0)
	var fwd = Vector3(sin(yaw), 0, cos(yaw))
	for e in get_tree().get_nodes_in_group("enemies"):
		if not e.dead and _in_cone(pos, fwd, e.translation):
			e.server_damage(dmg, attacker_id)
	if _in_dojo(pos):                  # duelos entre jugadores solo dentro del dojo
		for id in spawned:
			if id == attacker_id:
				continue
			var p = spawned[id]
			if not p.dead and _in_dojo(p.translation) and _in_cone(pos, fwd, p.translation):
				p.rpc("take_damage", dmg * 0.5, attacker_id)


# Un cliente pide golpear; el servidor usa SU copia de la posición del jugador.
remote func request_hit(_pos, yaw, dmg):
	var id = get_tree().get_rpc_sender_id()
	var p = spawned.get(id)
	if p == null or p.dead:
		return
	server_hit(id, p.translation, yaw, dmg)


func damage_player(id, amount):
	var p = spawned.get(id)
	if p != null and not p.dead:
		p.rpc("take_damage", amount, 0)


# ---------------------------------------------------------------
# NPCs y enemigos
# ---------------------------------------------------------------
func _spawn_npcs():
	var chars = Models.characters()
	var defs = [
		{"id": "sato", "name": "Prof. Sato", "pos": Vector3(0, 0.05, -3), "yaw": 0.0,
			"color": Color(0.6, 0.4, 0.8),
			"lines": ["Recuerda llegar puntual a clase.", "Los estudiantes aplicados siempre llegan lejos.", "Las clases son de 8:00 a 12:30 y de 13:30 a 15:00."]},
		{"id": "takeda", "name": "Capitán Takeda", "pos": Vector3(20, 0.05, 4), "yaw": -PI / 2.0,
			"color": Color(0.95, 0.6, 0.2),
			"lines": ["El club de kendo entrena después de clases.", "Dentro del dojo puedes duelear con otros estudiantes.", "Esquivar a tiempo vale más que golpear fuerte."]},
		{"id": "mika", "name": "Mika (biblioteca)", "pos": Vector3(-10, 0.05, 11.5), "yaw": 0.0,
			"color": Color(0.4, 0.8, 0.5),
			"lines": ["Los libros brillan de azul, ¡no los pises!", "Cada día aparecen libros nuevos por la escuela.", "Leer también sube tu nivel de estudio."]}
	]
	for i in range(defs.size()):
		var d = defs[i]
		var n = NPCScript.new()
		n.name = "NPC_" + d.id
		n.npc_id = d.id
		n.npc_name = d.name
		n.color = d.color
		n.yaw = d.yaw
		n.idle_lines = d.lines
		if chars.size() > 0:
			n.model_path = chars[(i + 1) % chars.size()]
		n.translation = d.pos
		add_child(n)


func _spawn_enemies():
	var chars = Models.characters()
	var spots = [Vector3(24, 0.1, 0), Vector3(29, 0.1, 2), Vector3(25, 0.1, 8)]
	for i in range(spots.size()):
		var e = EnemyScript.new()
		e.name = "Dummy%d" % (i + 1)
		e.kind = "dummy"
		e.enemy_name = "Muñeco de práctica"
		e.max_health = 40.0
		e.respawn_time = 12.0
		e.xp_reward = 8
		e.money_reward = 5
		e.home = spots[i]
		add_child(e)

	var r = EnemyScript.new()
	r.name = "Rival"
	r.kind = "rival"
	r.enemy_name = "Kurogane (rival)"
	r.max_health = 220.0
	r.speed = 3.8
	r.attack_damage = 18.0
	r.respawn_time = 45.0
	r.xp_reward = 120
	r.money_reward = 80
	r.home = Vector3(-30, 0.1, 8)
	if chars.size() > 0:
		r.model_path = chars[chars.size() - 1]
	add_child(r)


# ---------------------------------------------------------------
# Zonas y libros
# ---------------------------------------------------------------
func _is_local(body):
	return body.is_in_group("players") and body.is_network_master()


func _zone(zone_name, center, size):
	var a = Area.new()
	a.translation = center
	var cs = CollisionShape.new()
	var bs = BoxShape.new()
	bs.extents = size / 2.0
	cs.shape = bs
	a.add_child(cs)
	a.connect("body_entered", self, "_on_zone_enter", [zone_name])
	a.connect("body_exited", self, "_on_zone_exit", [zone_name])
	add_child(a)


func _build_zones():
	_zone("aula", Vector3(-10, 2, -12), Vector3(10, 4, 16))
	_zone("aula", Vector3(10, 2, -12), Vector3(10, 4, 16))
	_zone("dojo", Vector3(26, 2, 4), Vector3(16, 4, 16))


func _on_zone_enter(body, zone_name):
	if not _is_local(body):
		return
	if zone_name == "aula":
		aula_count += 1
		Quests.notify("zone", "aula")
	elif zone_name == "dojo":
		get_tree().call_group("hud", "toast", "Dojo: aquí puedes duelear con otros jugadores")


func _on_zone_exit(body, zone_name):
	if _is_local(body) and zone_name == "aula":
		aula_count = max(0, aula_count - 1)


func _spawn_books():
	for b in books:
		if is_instance_valid(b):
			b.queue_free()
	books.clear()
	books_by_id.clear()
	for i in range(BOOK_SPOTS.size()):
		var a = Area.new()
		a.name = "Book_%d" % i
		a.translation = BOOK_SPOTS[i]
		a.set_meta("book_id", i)
		var cs = CollisionShape.new()
		var ss = SphereShape.new()
		ss.radius = 0.9
		cs.shape = ss
		a.add_child(cs)
		var mi = MeshInstance.new()
		var cm = CubeMesh.new()
		cm.size = Vector3(0.45, 0.12, 0.34)
		mi.mesh = cm
		var mat = SpatialMaterial.new()
		mat.albedo_color = Color(0.2, 0.45, 1.0)
		mat.emission_enabled = true
		mat.emission = Color(0.1, 0.35, 1.0)
		mat.emission_energy = 1.5
		mi.material_override = mat
		a.add_child(mi)
		a.connect("body_entered", self, "_on_book", [i])
		add_child(a)
		books.append(a)
		books_by_id[i] = a


func _on_book(body, book_id):
	if not _is_local(body) or not books_by_id.has(book_id):
		return
	var collector_id = int(body.player_id)
	if get_tree().is_network_server():
		_server_collect_book(collector_id, book_id)
	else:
		rpc_id(1, "request_collect_book", book_id)


remote func request_collect_book(book_id):
	if not get_tree().is_network_server():
		return
	_server_collect_book(get_tree().get_rpc_sender_id(), int(book_id))


func _server_collect_book(player_id, book_id):
	if not get_tree().is_network_server() or not books_by_id.has(book_id):
		return
	var p = spawned.get(player_id)
	var book = books_by_id.get(book_id)
	if p == null or book == null or p.dead:
		return
	if p.global_transform.origin.distance_to(book.global_transform.origin) > 2.0:
		return
	rpc("remove_book", book_id, player_id)


remotesync func remove_book(book_id, collector_id):
	var book = books_by_id.get(book_id)
	if book != null and is_instance_valid(book):
		books.erase(book)
		books_by_id.erase(book_id)
		book.queue_free()
	if int(collector_id) == get_tree().get_network_unique_id():
		Quests.notify("collect", "book")
		get_tree().call_group("hud", "toast", "Encontraste un libro")


func _on_new_day(day_number):
	if not get_tree().is_network_server():
		return
	rpc("refresh_books_for_new_day", day_number)


remotesync func refresh_books_for_new_day(_day_number):
	_spawn_books()
	get_tree().call_group("hud", "toast", "Nuevo día: " + GameClock.DAY_NAMES[GameClock.weekday_index()])


# ---------------------------------------------------------------
# Entorno, luz y ciclo día/noche (GLES2)
# ---------------------------------------------------------------
func _build_environment():
	var sky = ProceduralSky.new()
	sky.sky_top_color = Color(0.35, 0.55, 0.85)
	sky.sky_horizon_color = Color(0.85, 0.8, 0.75)
	sky.ground_horizon_color = Color(0.85, 0.8, 0.75)
	sky.ground_bottom_color = Color(0.3, 0.3, 0.3)
	sky.sun_latitude = 35.0
	sky.sun_longitude = 40.0

	env = Environment.new()
	env.background_mode = Environment.BG_SKY
	env.background_sky = sky
	env.ambient_light_color = Color(1.0, 0.96, 0.9)
	env.ambient_light_energy = 0.9
	env.ambient_light_sky_contribution = 0.3
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.adjustment_enabled = true
	env.adjustment_contrast = 1.08
	env.adjustment_saturation = 1.15
	env.fog_enabled = true
	env.fog_color = Color(0.82, 0.84, 0.9)
	env.fog_depth_enabled = true
	env.fog_depth_begin = 45.0
	env.fog_depth_end = 140.0

	var we = WorldEnvironment.new()
	we.environment = env
	add_child(we)


func _build_light():
	sun = DirectionalLight.new()
	sun.rotation_degrees = Vector3(-40, -40, 0)
	sun.light_color = Color(1.0, 0.93, 0.8)
	sun.light_energy = 1.1
	sun.shadow_enabled = true
	sun.directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_2_SPLITS
	sun.directional_shadow_max_distance = 80.0
	sun.shadow_bias = 0.08
	add_child(sun)


func _update_sky():
	var dl = GameClock.daylight()
	var elev = clamp(GameClock.sun_elevation_deg(), 10.0, 170.0)
	sun.rotation_degrees = Vector3(-elev, -40, 0)
	var h = sin(deg2rad(GameClock.sun_elevation_deg()))
	sun.light_color = Color(1.0, 0.6, 0.38).linear_interpolate(Color(1.0, 0.95, 0.85), clamp(h * 2.5, 0.0, 1.0))
	sun.light_energy = 1.1 * dl
	sun.shadow_enabled = dl > 0.05
	env.ambient_light_energy = lerp(0.4, 0.9, dl)
	env.ambient_light_color = Color(0.4, 0.45, 0.75).linear_interpolate(Color(1.0, 0.96, 0.9), dl)
	env.background_energy = lerp(0.12, 1.0, dl)
	env.fog_color = Color(0.05, 0.06, 0.12).linear_interpolate(Color(0.82, 0.84, 0.9), dl)


func _process(delta):
	_update_sky()
	for b in books:
		if is_instance_valid(b):
			b.rotation.y += delta * 1.5

	# Tiempo de estudio: dentro de un aula (cuenta zona siempre, estudio solo en horario de clases)
	if aula_count > 0:
		study_acc += delta
		if study_acc >= 1.0:
			study_acc -= 1.0
			Quests.notify("zone", "aula")
			if GameClock.is_class_time():
				Quests.notify("study", "aula", 1)
				study_ticks += 1
				if study_ticks % 10 == 0:
					Stats.add_study(1)
