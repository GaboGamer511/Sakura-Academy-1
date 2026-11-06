extends Node
# Autoload "Network": conexión ENet, registro de jugadores, chat y estado de escritura.
# El servidor mantiene la lista autoritativa y distribuye altas/bajas a todos los peers.

signal player_list_changed
signal connected_ok
signal connection_failed
signal peer_left(id)
signal server_closed
signal chat_received(who, text)

const PORT = 7777
const MAX_PLAYERS = 8

var players = {}          # id -> nombre
var models = {}           # id -> ruta del modelo elegido
var my_name = "Jugador"
var my_model = ""
var game_started = false
var typing = false


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_ok")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")


func host_game(player_name, model_path = ""):
	my_name = player_name.strip_edges()
	if my_name == "":
		my_name = "Jugador"
	my_model = model_path
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err != OK:
		return err
	get_tree().network_peer = peer
	players.clear()
	models.clear()
	players[1] = my_name
	models[1] = my_model
	game_started = false
	emit_signal("player_list_changed")
	return OK


func join_game(player_name, ip, model_path = ""):
	my_name = player_name.strip_edges()
	if my_name == "":
		my_name = "Jugador"
	my_model = model_path
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(ip, PORT)
	if err != OK:
		return err
	get_tree().network_peer = peer
	return OK


func leave_game():
	if get_tree().network_peer:
		get_tree().network_peer.close_connection()
	get_tree().network_peer = null
	players.clear()
	models.clear()
	game_started = false
	typing = false


func start_game():
	if get_tree().is_network_server():
		rpc("load_world")


remotesync func load_world():
	game_started = true
	get_tree().change_scene("res://World.tscn")


func send_chat(text):
	text = text.strip_edges().substr(0, 120)
	if text != "":
		rpc("chat_msg", my_name, text)


remotesync func chat_msg(who, text):
	emit_signal("chat_received", who, text)


# El servidor comparte el roster completo con el jugador que acaba de entrar.
remote func receive_roster(roster_players, roster_models, started):
	if get_tree().is_network_server():
		return
	if typeof(roster_players) != TYPE_DICTIONARY or typeof(roster_models) != TYPE_DICTIONARY:
		return
	players = roster_players.duplicate(true)
	models = roster_models.duplicate(true)
	game_started = bool(started)
	emit_signal("player_list_changed")


# El cliente se registra ante el servidor al completar la conexión.
remote func register_player(player_name, model_path):
	if not get_tree().is_network_server():
		return
	var id = get_tree().get_rpc_sender_id()
	if id <= 1 or id > 2147483647:
		return
	if players.has(id):
		return
	if players.size() >= MAX_PLAYERS:
		var peer = get_tree().network_peer
		if peer is NetworkedMultiplayerENet:
			peer.disconnect_peer(id, true)
		return
	var safe_name = str(player_name).strip_edges().substr(0, 24)
	if safe_name == "":
		safe_name = "Jugador"
	var safe_model = str(model_path)
	if not safe_model.begins_with("res://models/"):
		safe_model = ""
	# Solo se acepta una ruta local de modelos. Nunca se carga una ruta arbitraria.
	rpc("register_player_update", id, safe_name, safe_model)


remotesync func register_player_update(id, player_name, model_path):
	players[id] = player_name
	models[id] = model_path
	emit_signal("player_list_changed")


remotesync func remove_player_update(id):
	players.erase(id)
	models.erase(id)
	emit_signal("peer_left", id)
	emit_signal("player_list_changed")


func _on_peer_connected(id):
	if not get_tree().is_network_server():
		return
	# El roster inicial se envía antes de cualquier cambio de escena.
	rpc_id(id, "receive_roster", players.duplicate(true), models.duplicate(true), game_started)
	# ENet conserva el orden de los RPC fiables: el roster llega antes que load_world.
	if game_started:
		rpc_id(id, "load_world")


func _on_peer_disconnected(id):
	if not get_tree().is_network_server():
		return
	if not players.has(id):
		return
	rpc("remove_player_update", id)


func _on_connected_ok():
	var me = get_tree().get_network_unique_id()
	players[me] = my_name
	models[me] = my_model
	# Registro autoritativo; el servidor retransmite la entrada al resto.
	rpc_id(1, "register_player", my_name, my_model)
	emit_signal("connected_ok")
	emit_signal("player_list_changed")


func _on_connection_failed():
	leave_game()
	emit_signal("connection_failed")


func _on_server_disconnected():
	leave_game()
	emit_signal("server_closed")
	get_tree().change_scene("res://Main.tscn")
