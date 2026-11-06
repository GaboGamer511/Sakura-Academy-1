extends SceneTree
# Prueba real de loopback: levantar un servidor y conectar dos clientes.
# Argumentos: --role=server o --role=client
# El servidor permanece activo después de ver a los dos clientes para no
# desconectarlos antes de que ambos puedan completar su comprobación.

const NetworkScript = preload("res://Network.gd")

var network_node = null
var role = ""
var elapsed = 0.0
var full_roster_elapsed = 0.0
var reached_full_roster = false


func _init():
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--role="):
			role = argument.replace("--role=", "")
	call_deferred("_start_probe")


func _start_probe():
	if role != "server" and role != "client":
		_fail("Argumento --role inválido")
		return

	network_node = NetworkScript.new()
	get_root().add_child(network_node)
	network_node.connect("player_list_changed", self, "_on_roster_changed")
	network_node.connect("connected_ok", self, "_on_connected")
	network_node.connect("connection_failed", self, "_on_connection_failed")
	network_node.connect("server_closed", self, "_on_server_closed")

	if role == "server":
		var err = network_node.host_game("CI Host")
		if err != OK:
			_fail("No se pudo iniciar el servidor ENet: %d" % err)
			return
		print("NETWORK_SMOKE_SERVER_READY")
	else:
		var err = network_node.join_game("CI Client", "127.0.0.1")
		if err != OK:
			_fail("No se pudo iniciar el cliente ENet: %d" % err)
			return
		print("NETWORK_SMOKE_CLIENT_CONNECTING")

	_watch_roster()


func _on_roster_changed():
	print("NETWORK_SMOKE_ROSTER role=%s peers=%d" % [role, network_node.players.size()])


func _on_connected():
	print("NETWORK_SMOKE_CONNECTED role=%s" % role)


func _on_connection_failed():
	_fail("ENet notificó connection_failed")


func _on_server_closed():
	if not reached_full_roster:
		_fail("El servidor se cerró antes de completar la prueba")


func _watch_roster():
	while elapsed < 35.0:
		yield(create_timer(0.25), "timeout")
		elapsed += 0.25

		var peer_count = 0 if network_node == null else network_node.players.size()
		if peer_count >= 3 and not reached_full_roster:
			reached_full_roster = true
			print("NETWORK_SMOKE_FULL_ROSTER role=%s peers=%d" % [role, peer_count])

		if role == "server" and reached_full_roster:
			# El host da margen a los clientes para terminar y desconectarse.
			full_roster_elapsed += 0.25
		elif role == "client" and peer_count >= 3:
			full_roster_elapsed += 0.25
		else:
			full_roster_elapsed = 0.0

		var required_time = 6.0 if role == "server" else 2.0
		if reached_full_roster and full_roster_elapsed >= required_time:
			print("NETWORK_SMOKE_OK role=%s peers=%d" % [role, peer_count])
			network_node.leave_game()
			quit(0)
			return

	_fail("Timeout: role=%s roster=%d connected_full=%s" % [
		role,
		0 if network_node == null else network_node.players.size(),
		str(reached_full_roster)
	])


func _fail(message):
	push_error("NETWORK_SMOKE_FAILED: " + message)
	if network_node != null:
		network_node.leave_game()
	quit(1)
