extends Control
var root_ui
var objective_label
var status_label
var dialogue_panel
var dialogue_label
var dialogue_name
var notification_label
var pause_panel
var arrest_panel
var quest_visible = true
var notify_timer = 0.0
func _ready():
	add_to_group("hud")
	pause_mode = Node.PAUSE_MODE_PROCESS
	_build_ui()
	print("Sakura Academy: HUD listo")
	get_tree().paused = false
	pause_panel.visible = false
	arrest_panel.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if not ResourceLoader.exists("res://models/characters/Schoolkid.glb") or not ResourceLoader.exists("res://models/japanese_school_campus.glb"):
		notify("Recursos 3D reales pendientes: ejecuta INSTALAR_MODELOS.bat y vuelve a abrir el proyecto.")
	var scene_root = get_tree().get_root().find_node("World", true, false)
	var music = scene_root.get_node_or_null("AmbientMusic") if scene_root else null
	if music and not music.is_connected("finished", music, "play"):
		music.connect("finished", music, "play")
func _build_ui():
	set_anchors_and_margins_preset(Control.PRESET_WIDE)
	var top = Panel.new(); top.rect_position = Vector2(18,16); top.rect_size = Vector2(360,104); add_child(top)
	var title = Label.new(); title.text = "SAKURA ACADEMY  •  1.º DÍA"; title.rect_position = Vector2(14,8); title.rect_size = Vector2(330,24); top.add_child(title)
	status_label = Label.new(); status_label.text = "Reputación: 50   |   Ambiente: 100%"; status_label.rect_position = Vector2(14,37); status_label.rect_size = Vector2(330,22); top.add_child(status_label)
	objective_label = Label.new(); objective_label.text = "OBJETIVO  •  Habla con 3 estudiantes"; objective_label.rect_position = Vector2(14,65); objective_label.rect_size = Vector2(330,28); top.add_child(objective_label)
	var controls = Label.new(); controls.text = "WASD mover  •  Shift correr  •  Espacio saltar\nRatón cámara  •  E interactuar  •  Q objetivo  •  Esc pausa"; controls.add_color_override("font_color",Color(1,1,1)); controls.anchor_left = 0; controls.anchor_top = 1; controls.margin_left = 18; controls.margin_top = -64; controls.margin_right = 500; controls.margin_bottom = -12; add_child(controls)
	notification_label = Label.new(); notification_label.anchor_left=0.5; notification_label.anchor_right=0.5; notification_label.anchor_top=0.18; notification_label.anchor_bottom=0.18; notification_label.add_color_override("font_color",Color(1,1,1)); notification_label.margin_left=-260; notification_label.margin_right=260; notification_label.margin_bottom=34; notification_label.align=1; add_child(notification_label)
	dialogue_panel = Panel.new(); dialogue_panel.anchor_left=0.5; dialogue_panel.anchor_right=0.5; dialogue_panel.anchor_top=1; dialogue_panel.anchor_bottom=1; dialogue_panel.margin_left=-270; dialogue_panel.margin_right=270; dialogue_panel.margin_top=-150; dialogue_panel.margin_bottom=-18; dialogue_panel.visible=false; add_child(dialogue_panel)
	dialogue_name=Label.new(); dialogue_name.rect_position=Vector2(18,12); dialogue_name.rect_size=Vector2(500,25); dialogue_panel.add_child(dialogue_name)
	dialogue_label=Label.new(); dialogue_label.rect_position=Vector2(18,43); dialogue_label.rect_size=Vector2(500,65); dialogue_label.autowrap=true; dialogue_panel.add_child(dialogue_label)
	pause_panel = _make_overlay("SAKURA ACADEMY", "Una nueva jornada comienza", "CONTINUAR", "_on_continue")
	arrest_panel = _make_overlay("FIN DE LA JORNADA", "La seguridad intervino en el campus.", "VOLVER A INTENTAR", "_on_restart")
	arrest_panel.visible=false
func _make_overlay(heading, subheading, button_text, method):
	var panel=Control.new(); panel.anchor_right=1; panel.anchor_bottom=1; add_child(panel)
	var shade=ColorRect.new(); shade.anchor_right=1; shade.anchor_bottom=1; shade.color=Color(0.035,0.045,0.09,0.94); panel.add_child(shade)
	var h=Label.new(); h.text=heading; h.anchor_left=0.5; h.anchor_right=0.5; h.anchor_top=0.36; h.anchor_bottom=0.36; h.margin_left=-300; h.margin_right=300; h.margin_bottom=55; h.align=1; h.add_color_override("font_color",Color(0.95,0.75,0.84)); panel.add_child(h)
	var s=Label.new(); s.text=subheading; s.anchor_left=0.5; s.anchor_right=0.5; s.anchor_top=0.44; s.anchor_bottom=0.44; s.margin_left=-300; s.margin_right=300; s.margin_bottom=35; s.align=1; s.add_color_override("font_color",Color(0.93,0.93,0.96)); panel.add_child(s)
	var b=Button.new(); b.text=button_text; b.anchor_left=0.5; b.anchor_right=0.5; b.anchor_top=0.55; b.anchor_bottom=0.55; b.margin_left=-110; b.margin_right=110; b.margin_bottom=48; panel.add_child(b); b.connect("pressed",self,method)
	return panel
func _process(delta):
	if notify_timer>0:
		notify_timer-=delta
		if notify_timer<=0: notification_label.text=""
	status_label.text="Reputación: %d   |   Ambiente: %d%%   |   Objetos: %d/3" % [get_player_reputation(),int(GameManager.school_atmosphere),GameManager.collectibles]
	if GameManager.students_talked < 3:
		objective_label.text = "OBJETIVO 1/2  •  Conoce estudiantes (%d/3)" % GameManager.students_talked
	elif GameManager.collectibles < 3:
		objective_label.text = "OBJETIVO 2/2  •  Encuentra recuerdos (%d/3)" % GameManager.collectibles
	else:
		objective_label.text = "JORNADA COMPLETADA  •  ¡Bienvenida a Sakura Academy!"
	if GameManager.police_called and not arrest_panel.visible:
		notify("Alguien ha alertado a seguridad. ¡Busca una salida! Tiempo: %ds" % int(max(0,12-GameManager.police_timer)))
func get_player_reputation():
	var p=get_tree().get_root().find_node("Player",true,false)
	return p.reputation if p else 50
func notify(message):
	notification_label.text=message; notify_timer=3.2
func show_dialogue(who,line):
	dialogue_name.text=who
	dialogue_label.text=line+"\n\nPulsa E para seguir explorando."
	dialogue_panel.visible=true
func close_dialogue():
	dialogue_panel.visible=false
func item_collected(item,description):
	notify(item+" — "+description)
func toggle_quest():
	quest_visible=not quest_visible
	objective_label.visible=quest_visible
func show_arrest():
	arrest_panel.visible=true
	get_tree().paused=true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and not arrest_panel.visible:
		if pause_panel.visible:
			_on_continue()
		else:
			get_tree().paused=true
			pause_panel.visible=true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_continue():
	pause_panel.visible=false
	get_tree().paused=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _on_restart():
	GameManager.reset_game()
	get_tree().paused=false
	get_tree().reload_current_scene()
