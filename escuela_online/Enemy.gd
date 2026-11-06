extends KinematicBody
# Enemigo controlado por el SERVIDOR (host). Los demás peers solo reciben posición y vida.
# kind = "dummy" (muñeco quieto) o "rival" (ataca a los jugadores cercanos).

const Avatar = preload("res://Avatar.gd")
const GRAVITY = 25.0

var kind = "dummy"
var enemy_name = "Muñeco"
var model_path = ""
var max_health = 40.0
var health = 40.0
var dead = false
var home = Vector3.ZERO
var respawn_time = 15.0
var speed = 0.0
var attack_damage = 0.0
var xp_reward = 8
var money_reward = 5
var plate_height = 2.3

var avatar
var col
var dummy_mat
var velocity = Vector3.ZERO
var puppet_pos = Vector3.ZERO
var puppet_yaw = 0.0
var yaw = 0.0
var state = "idle"
var state_t = 0.0


func _ready():
	add_to_group("enemies")
	add_to_group("plate")
	translation = home
	puppet_pos = home
	health = max_health

	col = CollisionShape.new()
	var cap = CapsuleShape.new()
	cap.radius = 0.45
	cap.height = 1.0
	col.shape = cap
	col.rotation_degrees = Vector3(90, 0, 0)
	col.translation = Vector3(0, 0.9, 0)
	add_child(col)

	avatar = Avatar.new()
	avatar.has_sword = kind != "dummy"
	avatar.extra_scale = 1.12 if kind == "rival" else 1.0
	avatar.tint_strength = 0.0
	var avatar_color = Color(0.75, 0.15, 0.2) if kind == "rival" else Color(0.62, 0.45, 0.28)
	avatar.setup(model_path, avatar_color)
	add_child(avatar)


func get_plate_text():
	return enemy_name


func _physics_process(delta):
	if get_tree().is_network_server():
		_server_ai(delta)
		rpc_unreliable("sync_state", translation, yaw)
	else:
		var t = min(1.0, delta * 12.0)
		translation = translation.linear_interpolate(puppet_pos, t)
		yaw = _lerp_angle(yaw, puppet_yaw, t)
		if avatar:
			avatar.moving = translation.distance_to(puppet_pos) > 0.08
	if avatar:
		avatar.rotation.y = yaw


func _server_ai(delta):
	if dead or kind == "dummy":
		return
	state_t -= delta
	var target = _nearest_player(20.0)

	if state == "windup":
		if state_t <= 0.0:
			if target != null and _flat_dist(target) < 3.2:
				get_parent().damage_player(target.player_id, attack_damage)
			state = "recover"
			state_t = 0.9
		_apply_motion(Vector3.ZERO, delta)
		return
	if state == "recover":
		if state_t <= 0.0:
			state = "idle"
		_apply_motion(Vector3.ZERO, delta)
		return

	var move = Vector3.ZERO
	if target != null:
		var to = target.translation - translation
		to.y = 0
		var d = to.length()
		if d > 0.01:
			yaw = _lerp_angle(yaw, atan2(to.x, to.z), min(1.0, delta * 8.0))
		if d > 2.3:
			move = to.normalized() * speed
		else:
			state = "windup"
			state_t = 0.7
			rpc("swing")
	else:
		var back = home - translation
		back.y = 0
		if back.length() > 1.0:
			move = back.normalized() * speed * 0.6
			yaw = _lerp_angle(yaw, atan2(back.x, back.z), min(1.0, delta * 6.0))
	_apply_motion(move, delta)


func _apply_motion(move, delta):
	velocity.x = move.x
	velocity.z = move.z
	velocity.y -= GRAVITY * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	if avatar:
		avatar.moving = move.length() > 0.5


func _nearest_player(max_dist):
	var best = null
	var best_d = max_dist
	for p in get_tree().get_nodes_in_group("players"):
		if p.dead:
			continue
		var d = _flat_dist(p)
		if d < best_d:
			best_d = d
			best = p
	return best


func _flat_dist(n):
	var v = n.translation - translation
	v.y = 0
	return v.length()


# ---------------------------------------------------------------
# Daño (lo llama World.gd en el servidor)
# ---------------------------------------------------------------
func server_damage(amount, killer_id):
	if dead:
		return
	rpc("hurt", max(0.0, health - amount), killer_id)


remotesync func hurt(new_health, killer_id):
	var s = get_tree().get_rpc_sender_id()
	if s != 0 and s != 1:
		return
	health = new_health
	if avatar:
		avatar.flash()
	elif dummy_mat:
		dummy_mat.albedo_color = Color(1, 0.3, 0.25)
		get_tree().create_timer(0.12).connect("timeout", self, "_restore_dummy_color")
	if health <= 0.0 and not dead:
		_die(killer_id)


func _restore_dummy_color():
	if dummy_mat:
		dummy_mat.albedo_color = Color(0.62, 0.45, 0.28)


func _die(killer_id):
	dead = true
	visible = false
	col.set_deferred("disabled", true)
	if killer_id == get_tree().get_network_unique_id():
		Quests.notify("kill", kind)
		Stats.add_xp(xp_reward)
		Stats.add_money(money_reward)
		get_tree().call_group("hud", "toast", "%s derrotado (+%d XP, +¥%d)" % [enemy_name, xp_reward, money_reward])
	yield(get_tree().create_timer(respawn_time), "timeout")
	if not is_inside_tree():
		return
	dead = false
	health = max_health
	visible = true
	col.set_deferred("disabled", false)
	translation = home
	puppet_pos = home
	state = "idle"


remotesync func swing():
	if avatar:
		avatar.play_attack()


puppet func sync_state(pos, y):
	puppet_pos = pos
	puppet_yaw = y


func _lerp_angle(from, to, weight):
	var diff = fmod(to - from, TAU)
	diff = fmod(2.0 * diff, TAU) - diff
	return from + diff * weight
