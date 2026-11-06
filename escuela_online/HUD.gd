extends CanvasLayer
# Interfaz del juego (todo por código): barras, reloj, misiones, avisos, diálogo,
# chat y nombres sobre los personajes. Se controla con call_group("hud", "metodo", ...).

var hp_bar
var st_bar
var stats_label
var clock_label
var quest_label
var toast_label
var hint_label
var dlg_panel
var dlg_name
var dlg_text
var chat_log
var chat_edit

var toasts = []        # [texto, tiempo restante]
var chat_lines = []
var dlg_time = 0.0
var plates = {}        # instance_id -> Control
var plate_layer


func _ready():
	add_to_group("hud")
	layer = 5

	plate_layer = Control.new()
	plate_layer.set_anchors_and_margins_preset(Control.PRESET_WIDE)
	plate_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(plate_layer)

	# --- Arriba a la izquierda: vida, stamina, stats ---
	hp_bar = _bar(Vector2(20, 18), Vector2(260, 18), Color(0.85, 0.2, 0.25))
	st_bar = _bar(Vector2(20, 40), Vector2(260, 12), Color(0.95, 0.8, 0.2))
	stats_label = _label(Vector2(20, 58))

	# --- Arriba a la derecha: reloj ---
	clock_label = _label(Vector2(0, 18))
	clock_label.anchor_left = 1.0
	clock_label.anchor_right = 1.0
	clock_label.margin_left = -330
	clock_label.margin_right = -20
	clock_label.align = Label.ALIGN_RIGHT

	# --- Misiones (izquierda) ---
	quest_label = _label(Vector2(20, 130))
	quest_label.rect_min_size = Vector2(340, 0)

	# --- Avisos (centro arriba) ---
	toast_label = _label(Vector2(0, 80))
	toast_label.anchor_left = 0.5
	toast_label.anchor_right = 0.5
	toast_label.margin_left = -300
	toast_label.margin_right = 300
	toast_label.align = Label.ALIGN_CENTER

	# --- Pista de interacción ---
	hint_label = _label(Vector2(0, 0))
	hint_label.anchor_left = 0.5
	hint_label.anchor_right = 0.5
	hint_label.anchor_top = 1.0
	hint_label.anchor_bottom = 1.0
	hint_label.margin_left = -200
	hint_label.margin_right = 200
	hint_label.margin_top = -230
	hint_label.margin_bottom = -210
	hint_label.align = Label.ALIGN_CENTER

	# --- Diálogo (abajo al centro) ---
	dlg_panel = PanelContainer.new()
	dlg_panel.anchor_left = 0.5
	dlg_panel.anchor_right = 0.5
	dlg_panel.anchor_top = 1.0
	dlg_panel.anchor_bottom = 1.0
	dlg_panel.margin_left = -330
	dlg_panel.margin_right = 330
	dlg_panel.margin_top = -200
	dlg_panel.margin_bottom = -60
	dlg_panel.visible = false
	add_child(dlg_panel)
	var vb = VBoxContainer.new()
	dlg_panel.add_child(vb)
	dlg_name = Label.new()
	dlg_name.add_color_override("font_color", Color(1, 0.85, 0.4))
	vb.add_child(dlg_name)
	dlg_text = Label.new()
	dlg_text.autowrap = true
	dlg_text.rect_min_size = Vector2(620, 80)
	vb.add_child(dlg_text)

	# --- Chat (abajo a la izquierda) ---
	chat_log = _label(Vector2(0, 0))
	chat_log.anchor_top = 1.0
	chat_log.anchor_bottom = 1.0
	chat_log.margin_left = 20
	chat_log.margin_right = 420
	chat_log.margin_top = -190
	chat_log.margin_bottom = -50
	chat_log.valign = Label.VALIGN_BOTTOM
	chat_edit = LineEdit.new()
	chat_edit.anchor_top = 1.0
	chat_edit.anchor_bottom = 1.0
	chat_edit.margin_left = 20
	chat_edit.margin_right = 420
	chat_edit.margin_top = -44
	chat_edit.margin_bottom = -16
	chat_edit.placeholder_text = "Enter para chatear"
	chat_edit.visible = false
	chat_edit.connect("text_entered", self, "_on_chat_entered")
	add_child(chat_edit)

	Stats.connect("changed", self, "_refresh_stats")
	Quests.connect("changed", self, "_refresh_quests")
	Network.connect("chat_received", self, "_on_chat")
	_refresh_stats()
	_refresh_quests()


func _label(pos):
	var l = Label.new()
	l.rect_position = pos
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(l)
	return l


func _bar(pos, size, color):
	var b = ProgressBar.new()
	b.rect_position = pos
	b.rect_min_size = size
	b.rect_size = size
	b.percent_visible = false
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_stylebox_override("fg", _flat(color))
	b.add_stylebox_override("bg", _flat(Color(0, 0, 0, 0.55)))
	add_child(b)
	return b


func _flat(color):
	var s = StyleBoxFlat.new()
	s.bg_color = color
	return s


# ---------------------------------------------------------------
# Llamados desde otros scripts (call_group)
# ---------------------------------------------------------------
func set_bars(hp, max_hp, st, max_st):
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	st_bar.max_value = max_st
	st_bar.value = st


func set_hint(text):
	hint_label.text = text


func toast(text):
	toasts.append([text, 5.0])
	if toasts.size() > 4:
		toasts.pop_front()


func show_dialogue(who, text):
	dlg_name.text = who
	dlg_text.text = text
	dlg_panel.visible = true
	dlg_time = 8.0


# ---------------------------------------------------------------
func _refresh_stats():
	stats_label.text = "Nv %d    XP %d/%d    ¥%d    Estudio %d" % [Stats.level, Stats.xp, Stats.xp_needed(), Stats.money, Stats.study]


func _refresh_quests():
	quest_label.text = "MISIONES\n" + Quests.tracker_text()


func _on_chat(who, text):
	chat_lines.append("%s: %s" % [who, text])
	if chat_lines.size() > 7:
		chat_lines.pop_front()
	chat_log.text = PoolStringArray(chat_lines).join("\n")


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if (event.scancode == KEY_ENTER or event.scancode == KEY_KP_ENTER) and not Network.typing:
			Network.typing = true
			chat_edit.visible = true
			chat_edit.text = ""
			chat_edit.grab_focus()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.scancode == KEY_ESCAPE and Network.typing:
			_close_chat()


func _on_chat_entered(text):
	Network.send_chat(text)
	_close_chat()


func _close_chat():
	Network.typing = false
	chat_edit.release_focus()
	chat_edit.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	clock_label.text = GameClock.label()

	# Avisos
	var txt = ""
	for t in toasts:
		t[1] -= delta
		txt += t[0] + "\n"
	while toasts.size() > 0 and toasts[0][1] <= 0.0:
		toasts.pop_front()
	toast_label.text = txt.strip_edges()

	# Diálogo
	if dlg_panel.visible:
		dlg_time -= delta
		if dlg_time <= 0.0:
			dlg_panel.visible = false

	_update_plates()


# Nombres y barras de vida sobre los personajes (grupo "plate")
func _update_plates():
	var cam = get_viewport().get_camera()
	var seen = {}
	if cam:
		for n in get_tree().get_nodes_in_group("plate"):
			if not n.visible:
				continue
			var id = n.get_instance_id()
			seen[id] = true
			var pos = n.global_transform.origin + Vector3(0, n.plate_height, 0)
			var plate = plates.get(id)
			if plate == null:
				plate = _make_plate(n)
				plates[id] = plate
			var far = cam.global_transform.origin.distance_to(pos) > 40.0
			if cam.is_position_behind(pos) or far:
				plate.visible = false
				continue
			plate.visible = true
			plate.rect_position = cam.unproject_position(pos) - Vector2(60, 28)
			plate.get_node("name").text = n.get_plate_text()
			var bar = plate.get_node("bar")
			if bar.visible:
				bar.max_value = max(1.0, n.max_health)
				bar.value = n.health
	for id in plates.keys():
		if not seen.has(id) or not is_instance_valid(instance_from_id(id)):
			plates[id].queue_free()
			plates.erase(id)


func _make_plate(n):
	var root = Control.new()
	root.rect_size = Vector2(120, 30)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l = Label.new()
	l.name = "name"
	l.rect_position = Vector2(0, 0)
	l.rect_size = Vector2(120, 16)
	l.align = Label.ALIGN_CENTER
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(l)
	var b = ProgressBar.new()
	b.name = "bar"
	b.rect_position = Vector2(10, 19)
	b.rect_size = Vector2(100, 7)
	b.rect_min_size = Vector2(100, 7)
	b.percent_visible = false
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_stylebox_override("fg", _flat(Color(0.85, 0.2, 0.25)))
	b.add_stylebox_override("bg", _flat(Color(0, 0, 0, 0.55)))
	b.visible = "health" in n
	root.add_child(b)
	plate_layer.add_child(root)
	return root
