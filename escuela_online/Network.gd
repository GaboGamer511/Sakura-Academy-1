extends Node
# Autoload "Network": conexión ENet, lista de jugadores, chat y estado de escritura.

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
var typing = false        # true mientras se escribe en el chat (bloquea movimiento)


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_ok")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")


func host_game(player_name, model_path = ""):
	my_name = player_name
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
	emit_signal("player_list_changed")
	return OK


func join_game(player_name, ip, model_path = ""):
	my_name = player_name
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


# --- Solo el host llama a esto desde el lobby ---
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


# --- Señales de red ---
func _on_peer_connected(id):
	rpc_id(id, "register_player", my_name, my_model)
	if get_tree().is_network_server() and game_started:
		rpc_id(id, "load_world")


remote func register_player(player_name, model_path):
	var id = get_tree().get_rpc_sender_id()
	players[id] = player_name
	models[id] = model_path
	emit_signal("player_list_changed")


func _on_peer_disconnected(id):
	players.erase(id)
	models.erase(id)
	emit_signal("peer_left", id)
	emit_signal("player_list_changed")


func _on_connected_ok():
	var me = get_tree().get_network_unique_id()
	players[me] = my_name
	models[me] = my_model
	emit_signal("connected_ok")
	emit_signal("player_list_changed")


func _on_connection_failed():
	leave_game()
	emit_signal("connection_failed")


func _on_server_disconnected():
	leave_game()
	emit_signal("server_closed")
	get_tree().change_scene("res://Main.tscn")
