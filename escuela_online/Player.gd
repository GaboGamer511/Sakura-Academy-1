extends KinematicBody
# Jugador en tercera persona. El "master" (dueño) lo controla; los demás reciben su estado.
# El daño lo decide el servidor (World.gd); aquí solo se recibe y se aplica.

const Avatar = preload("res://Avatar.gd")

const SPEED = 6.0
const ROLL_SPEED = 14.0
const ROLL_TIME = 0.35
const ROLL_COST = 25.0
const ATTACK_COST = 15.0
const ATTACK_COOLDOWN = 0.45
const GRAVITY = 25.0
const MAX_STAMINA = 100.0
const STAMINA_REGEN = 20.0

var player_name = "Jugador"
var player_id = 1
var model_path = ""
var plate_height = 2.2

var health = 100.0
var max_health = 100.0
var dead = false
var death_timer = 0.0

var velocity = Vector3.ZERO
var stamina = MAX_STAMINA
var roll_timer = 0.0
var roll_dir = Vector3.ZERO
var attack_cd = 0.0

var cam_yaw = 0.0
var cam_pitch = -0.35
var cam_dist = 4.5

var avatar
var cam_pivot
var camera
var last_pos = Vector3.ZERO

# Estado recibido de la red (solo se usa en los puppets)
var puppet_pos = Vector3.ZERO
var puppet_yaw = 0.0


func _ready():
	add_to_group("players")
	puppet_pos = translation
	last_pos = translation

	# Colisión (en Godot 3 la cápsula del CollisionShape está tumbada: se gira 90°)
	var col = CollisionShape.new()
	var cap = CapsuleShape.new()
	cap.radius = 0.4
	cap.height = 1.0
	col.shape = cap
	col.rotation_degrees = Vector3(90, 0, 0)
	col.translation = Vector3(0, 0.9, 0)
	add_child(col)

	avatar = Avatar.new()
	avatar.has_sword = true
	avatar.tint_strength = 0.4
	avatar.setup(model_path, Color.from_hsv((player_id % 360) / 360.0, 0.6, 0.9))
	add_child(avatar)

	cam_pivot = Spatial.new()
	cam_pivot.translation = Vector3(0, 1.5, 0)
	add_child(cam_pivot)
	camera = Camera.new()
	camera.translation = Vector3(0, 0, cam_dist)
	camera.far = 300.0
	cam_pivot.add_child(camera)

	if is_network_master():
		camera.current = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		max_health = Stats.max_health()
		health = max_health
		Stats.connect("leveled_up", self, "_on_level_up")
	else:
		add_to_group("plate")


func get_plate_text():
	return player_name


func _on_level_up(_lvl):
	max_health = Stats.max_health()
	health = max_health


# ---------------------------------------------------------------
# Entrada
# ---------------------------------------------------------------
func _unhandled_input(event):
	if not is_network_master():
		return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cam_yaw -= event.relative.x * 0.003
		cam_pitch = clamp(cam_pitch - event.relative.y * 0.003, -1.2, 0.5)
	elif event is InputEventMouseButton and event.pressed:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.button_index == BUTTON_LEFT:
			_try_attack()
		elif event.button_index == BUTTON_WHEEL_UP:
			cam_dist = clamp(cam_dist - 0.4, 2.5, 8.0)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			cam_dist = clamp(cam_dist + 0.4, 2.5, 8.0)
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.scancode == KEY_E:
			_interact()


func _nearest_npc():
	var best = null
	var best_d = 3.2
	for n in get_tree().get_nodes_in_group("npc"):
		var d = n.global_transform.origin.distance_to(global_transform.origin)
		if d < best_d:
			best_d = d
			best = n
	return best


func _interact():
	if dead:
		return
	var n = _nearest_npc()
	if n:
		n.interact()


# ---------------------------------------------------------------
# Física
# ---------------------------------------------------------------
func _physics_process(delta):
	if is_network_master():
		_master_move(delta)
		rpc_unreliable("sync_state", translation, avatar.rotation.y, health, max_health, dead)
	else:
		var t = min(1.0, delta * 12.0)
		translation = translation.linear_interpolate(puppet_pos, t)
		avatar.rotation.y = _lerp_angle(avatar.rotation.y, puppet_yaw, t)

	var moved = translation - last_pos
	moved.y = 0
	avatar.moving = (moved.length() / max(delta, 0.0001)) > 0.8 and not dead
	avatar.dead = dead
	last_pos = translation
	camera.translation.z = lerp(camera.translation.z, cam_dist, min(1.0, delta * 8.0))


func _master_move(delta):
	attack_cd = max(0.0, attack_cd - delta)

	if dead:
		death_timer -= delta
		velocity.x = 0
		velocity.z = 0
		velocity.y -= GRAVITY * delta
		velocity = move_and_slide(velocity, Vector3.UP)
		if death_timer <= 0.0:
			rpc("revive", Vector3(rand_range(-3, 3), 1.5, rand_range(5, 9)))
		cam_pivot.rotation = Vector3(cam_pitch, cam_yaw, 0)
		return

	var input = Vector3.ZERO
	if not Network.typing:
		if Input.is_key_pressed(KEY_W): input.z -= 1
		if Input.is_key_pressed(KEY_S): input.z += 1
		if Input.is_key_pressed(KEY_A): input.x -= 1
		if Input.is_key_pressed(KEY_D): input.x += 1
	input = input.normalized()
	var dir = Basis(Vector3.UP, cam_yaw).xform(input)

	if roll_timer > 0.0:
		roll_timer -= delta
		velocity.x = roll_dir.x * ROLL_SPEED
		velocity.z = roll_dir.z * ROLL_SPEED
	else:
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED
		stamina = min(MAX_STAMINA, stamina + STAMINA_REGEN * delta)
		if not Network.typing and Input.is_key_pressed(KEY_SPACE) and stamina >= ROLL_COST and is_on_floor():
			stamina -= ROLL_COST
			roll_timer = ROLL_TIME
			if dir.length() > 0.1:
				roll_dir = dir
			else:
				var y = avatar.rotation.y
				roll_dir = Vector3(sin(y), 0, cos(y))

	velocity.y -= GRAVITY * delta
	velocity = move_and_slide(velocity, Vector3.UP)

	var face = roll_dir if roll_timer > 0.0 else dir
	if face.length() > 0.1:
		var target = atan2(face.x, face.z)
		avatar.rotation.y = _lerp_angle(avatar.rotation.y, target, min(1.0, delta * 14.0))

	cam_pivot.rotation = Vector3(cam_pitch, cam_yaw, 0)

	get_tree().call_group("hud", "set_bars", health, max_health, stamina, MAX_STAMINA)
	var npc = _nearest_npc()
	get_tree().call_group("hud", "set_hint", ("[E] Hablar con " + npc.npc_name) if npc else "")


# ---------------------------------------------------------------
# Combate
# ---------------------------------------------------------------
func _try_attack():
	if dead or attack_cd > 0.0 or stamina < ATTACK_COST or Network.typing:
		return
	stamina -= ATTACK_COST
	attack_cd = ATTACK_COOLDOWN
	rpc("do_attack")
	var dmg = Stats.attack_damage()
	yield(get_tree().create_timer(0.15), "timeout")   # el golpe conecta a mitad del swing
	if dead or not is_inside_tree():
		return
	var world = get_parent()
	if get_tree().is_network_server():
		world.server_hit(1, translation, avatar.rotation.y, dmg)
	else:
		world.rpc_id(1, "request_hit", translation, avatar.rotation.y, dmg)


# Se ejecuta en TODOS los peers para que todos vean el golpe.
remotesync func do_attack():
	avatar.play_attack()


# Lo manda el servidor. Solo el dueño del jugador cambia su vida real.
remotesync func take_damage(amount, _from_id):
	var s = get_tree().get_rpc_sender_id()
	if s != 0 and s != 1:
		return
	if dead:
		return
	if is_network_master():
		if roll_timer > 0.0:
			return                       # invulnerable mientras esquivas
		avatar.flash()
		health = max(0.0, health - amount)
		if health <= 0.0:
			_die()
	else:
		avatar.flash()


func _die():
	dead = true
	death_timer = 3.0
	Stats.money = int(Stats.money * 0.9)
	Stats.emit_signal("changed")
	get_tree().call_group("hud", "toast", "Te derrotaron... (pierdes 10% de tu dinero)")


remotesync func revive(pos):
	dead = false
	health = max_health
	translation = pos
	puppet_pos = pos
	velocity = Vector3.ZERO
	roll_timer = 0.0


# Los puppets reciben el estado del dueño.
puppet func sync_state(pos, yaw, hp, max_hp, is_dead):
	puppet_pos = pos
	puppet_yaw = yaw
	health = hp
	max_health = max_hp
	dead = is_dead


func _lerp_angle(from, to, weight):
	var diff = fmod(to - from, TAU)
	diff = fmod(2.0 * diff, TAU) - diff
	return from + diff * weight
