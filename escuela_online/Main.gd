extends Control
# Lobby: nombre, personaje, crear partida / unirse por IP, y empezar. UI por código.

const Models = preload("res://Models.gd")

var name_edit
var ip_edit
var char_option
var host_btn
var join_btn
var start_btn
var status
var list
var char_paths = []


func _ready():
	set_anchors_and_margins_preset(Control.PRESET_WIDE)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	var bg = ColorRect.new()
	bg.color = Color(0.12, 0.14, 0.2)
	bg.set_anchors_and_margins_preset(Control.PRESET_WIDE)
	add_child(bg)

	var center = CenterContainer.new()
	center.set_anchors_and_margins_preset(Control.PRESET_WIDE)
	add_child(center)

	var box = VBoxContainer.new()
	box.rect_min_size = Vector2(400, 0)
	box.add_constant_override("separation", 10)
	center.add_child(box)

	var title = Label.new()
	title.text = "ESCUELA ONLINE  (beta)"
	title.align = Label.ALIGN_CENTER
	box.add_child(title)

	name_edit = LineEdit.new()
	name_edit.placeholder_text = "Tu nombre"
	name_edit.text = "Estudiante" + str(randi() % 100)
	box.add_child(name_edit)

	char_option = OptionButton.new()
	char_paths = Models.characters()
	if char_paths.size() == 0:
		char_option.add_item("Personaje automático (instala un GLB riggeado)")
	else:
		for p in char_paths:
			char_option.add_item(p.get_file().get_basename())
	box.add_child(char_option)

	ip_edit = LineEdit.new()
	ip_edit.placeholder_text = "IP del anfitrión"
	ip_edit.text = "127.0.0.1"
	box.add_child(ip_edit)

	host_btn = Button.new()
	host_btn.text = "Crear partida (host)"
	host_btn.connect("pressed", self, "_on_host")
	box.add_child(host_btn)

	join_btn = Button.new()
	join_btn.text = "Unirse"
	join_btn.connect("pressed", self, "_on_join")
	box.add_child(join_btn)

	list = ItemList.new()
	list.rect_min_size = Vector2(0, 110)
	box.add_child(list)

	start_btn = Button.new()
	start_btn.text = "Empezar partida"
	start_btn.visible = false
	start_btn.connect("pressed", self, "_on_start")
	box.add_child(start_btn)

	status = Label.new()
	status.text = "Crea una partida o únete con la IP del anfitrión."
	status.autowrap = true
	box.add_child(status)

	var help = Label.new()
	help.text = "WASD mover | Espacio esquivar | Clic izq. atacar | E hablar | Enter chat | Rueda zoom | Esc soltar mouse"
	help.autowrap = true
	help.modulate = Color(1, 1, 1, 0.6)
	box.add_child(help)

	Network.connect("player_list_changed", self, "_refresh_list")
	Network.connect("connected_ok", self, "_on_connected_ok")
	Network.connect("connection_failed", self, "_on_failed")
	_refresh_list()


func _chosen_model():
	if char_paths.size() == 0:
		return Models.best_character()
	return char_paths[char_option.selected]


func _on_host():
	var err = Network.host_game(name_edit.text.strip_edges(), _chosen_model())
	if err != OK:
		status.text = "No se pudo crear la partida (¿puerto ocupado?)."
		return
	host_btn.disabled = true
	join_btn.disabled = true
	char_option.disabled = true
	start_btn.visible = true
	status.text = "Partida creada en el puerto %d. Espera a tus amigos y pulsa Empezar." % Network.PORT


func _on_join():
	var err = Network.join_game(name_edit.text.strip_edges(), ip_edit.text.strip_edges(), _chosen_model())
	if err != OK:
		status.text = "No se pudo iniciar la conexión."
		return
	host_btn.disabled = true
	join_btn.disabled = true
	char_option.disabled = true
	status.text = "Conectando..."


func _on_connected_ok():
	status.text = "Conectado. Esperando a que el anfitrión empiece..."


func _on_failed():
	host_btn.disabled = false
	join_btn.disabled = false
	char_option.disabled = false
	status.text = "No se pudo conectar. Revisa la IP y el puerto."


func _on_start():
	Network.start_game()


func _refresh_list():
	list.clear()
	for id in Network.players:
		var label = Network.players[id]
		if id == 1:
			label += "  (host)"
		list.add_item(label)
