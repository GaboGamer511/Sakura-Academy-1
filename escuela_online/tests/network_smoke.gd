extends SceneTree
# Prueba real de loopback: levantar un servidor y conectar dos clientes.
# Argumentos: --role=server o --role=client
# Se usa en GitHub Actions, no forma parte del juego.

const NetworkScript = preload("res://Network.gd")

var network_node = null
var role = ""


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


func _watch_roster():
	var elapsed = 0.0
	var stable_time = 0.0
	while elapsed < 35.0:
		yield(create_timer(0.25), "timeout")
		elapsed += 0.25
		if network_node != null and network_node.players.size() >= 3:
			stable_time += 0.25
			if stable_time >= 2.0:
				print("NETWORK_SMOKE_OK role=%s peers=%d" % [role, network_node.players.size()])
				network_node.leave_game()
				quit(0)
				return
		else:
			stable_time = 0.0
	_fail("Timeout: role=%s roster=%d" % [role, 0 if network_node == null else network_node.players.size()])


func _fail(message):
	push_error("NETWORK_SMOKE_FAILED: " + message)
	quit(1)
