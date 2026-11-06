extends KinematicBody

enum Mood { CALM, CURIOUS, SUSPICIOUS, AFRAID }
export(String) var student_name = "Estudiante"
export(int) var social_group = 0
export(int) var gender = 0
export(float) var speed = 1.45
export(float) var height_scale = 1.0
export(float) var build_scale = 1.0
var mood = Mood.CALM
var player = null
var velocity = Vector3.ZERO
var points = []
var point_index = 0
var wait_time = 0.0
var affinity = 0
var suspicion = 0.0
var dialogue_index = 0
var schedule_phase = 0
onready var visual = get_node_or_null("CharacterVisual")

func _ready():
	add_to_group("students")
	player = get_tree().get_root().find_node("Player", true, false)
	if visual:
		visual.set_appearance(social_group, gender, height_scale, build_scale)
	var p = global_transform.origin
	points = [p, p + Vector3(3.5, 0, 1.5), p + Vector3(-2.5, 0, 3.0), p + Vector3(1.0, 0, -3.5)]
	wait_time = rand_range(1.0, 4.0)

func _physics_process(delta):
	if mood == Mood.AFRAID:
		if player:
			var away = global_transform.origin - player.global_transform.origin
			away.y = 0
			if away.length() > 0.1:
				velocity = move_and_slide(away.normalized() * speed * 1.8, Vector3.UP)
				look_at(global_transform.origin + away, Vector3.UP)
		return
	wait_time -= delta
	if wait_time <= 0:
		var target = points[point_index]
		var direction = target - global_transform.origin
		direction.y = 0
		if direction.length() < 0.65:
			point_index = (point_index + 1) % points.size()
			wait_time = rand_range(1.8, 4.8)
			velocity = Vector3.ZERO
		else:
			direction = direction.normalized()
			velocity = move_and_slide(direction * speed, Vector3.UP)
			look_at(global_transform.origin + direction, Vector3.UP)
	if player:
		var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
		if distance_to_player < 2.6:
			var player_velocity = player.get("velocity")
			var player_running = false
			if typeof(player_velocity) == TYPE_VECTOR3:
				player_running = Vector2(player_velocity.x, player_velocity.z).length() > 5.8
			if GameManager.is_bloody or player_running:
				suspicion += delta * (5.0 if GameManager.is_bloody else 0.85)
				mood = Mood.SUSPICIOUS
				if suspicion > 3.0:
					alarm()
			elif mood == Mood.CALM:
				mood = Mood.CURIOUS
		else:
			suspicion = max(0.0, suspicion - delta * 0.35)
			if suspicion < 0.1 and mood in [Mood.CURIOUS, Mood.SUSPICIOUS]:
				mood = Mood.CALM

func talk_to(actor):
	affinity += 1
	suspicion = max(0.0, suspicion - 1.5)
	if mood == Mood.SUSPICIOUS: mood = Mood.CALM
	GameManager.register_student_talk(student_name)
	actor.reputation = clamp(actor.reputation + 1, 0, 100)
	var lines = ["¡Hola! ¿Ya conoces la academia?", "Hoy los clubes están preparando actividades."]
	match social_group:
		1:
			lines = ["¡Me encanta cómo queda el uniforme con estos accesorios!", "Luego iremos a la cafetería con las chicas.", "¿Ya viste las flores del patio? ¡Son preciosas!"]
		2:
			lines = ["No te preocupes, solo quiero pasar el día tranquilo.", "El gimnasio está libre después de clases.", "Si necesitas un descanso, el patio suele estar vacío."]
		3:
			lines = ["El consejo estudiantil prepara un evento esta semana.", "La academia tiene muchos rincones bonitos para fotos.", "Todos hablan de las actividades del festival."]
		4:
			lines = ["Entrenamos en la cancha casi todas las tardes.", "¡Un poco de ejercicio ayuda a despejar la mente!", "El gimnasio tiene buen espacio para practicar."]
		5:
			lines = ["La biblioteca tiene libros nuevos este semestre.", "Estoy organizando mis apuntes para los exámenes.", "¿Sabías que el club de ciencias se reúne los jueves?"]
		_:
			lines = ["¡Hola! ¿Ya conoces la academia?", "Hoy los clubes están preparando actividades.", "El cerezo del patio es el mejor lugar para descansar.", "¿Has visitado la biblioteca? Es muy tranquila."]
	var line = lines[dialogue_index % lines.size()]
	dialogue_index += 1
	get_tree().call_group("hud", "show_dialogue", student_name, line)

func alarm():
	mood = Mood.AFRAID
	GameManager.trigger_police_alert()
