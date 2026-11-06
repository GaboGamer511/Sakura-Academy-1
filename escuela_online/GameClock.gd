extends Node
# Autoload "GameClock": hora del juego, día de la semana y periodo escolar.
# 1 segundo real = 1 minuto del juego (un día completo dura 24 minutos reales).

signal period_changed(period_name)
signal new_day(day_number)

const SECONDS_PER_GAME_MINUTE = 1.0
const DAY_NAMES = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]

var minutes = 7.0 * 60.0 + 30.0     # empieza a las 07:30
var day = 1
var period = ""
var _sync_timer = 0.0


func _ready():
	period = get_period()


func _process(delta):
	minutes += delta / SECONDS_PER_GAME_MINUTE
	if minutes >= 1440.0:
		minutes -= 1440.0
		day += 1
		emit_signal("new_day", day)
	var p = get_period()
	if p != period:
		period = p
		emit_signal("period_changed", p)
		get_tree().call_group("hud", "toast", "Ahora: " + p)
	# El anfitrión manda la hora a los demás cada 5 segundos
	if get_tree().has_network_peer() and get_tree().is_network_server():
		_sync_timer += delta
		if _sync_timer >= 5.0:
			_sync_timer = 0.0
			rpc_unreliable("sync_time", minutes, day)


remote func sync_time(m, d):
	minutes = m
	day = d


func hour():
	return minutes / 60.0


func weekday_index():
	return (day - 1) % 7


func is_weekend():
	return weekday_index() >= 5


func get_period():
	var h = hour()
	if h < 7.0 or h >= 20.0:
		return "Noche"
	if is_weekend():
		return "Fin de semana"
	if h < 8.0:
		return "Mañana"
	if h < 12.5:
		return "Clases"
	if h < 13.5:
		return "Almuerzo"
	if h < 15.0:
		return "Clases"
	if h < 18.0:
		return "Clubes"
	return "Atardecer"


func is_class_time():
	return get_period() == "Clases"


func time_string():
	var m = int(minutes)
	return "%02d:%02d" % [m / 60, m % 60]


func label():
	return "%s  %s  -  %s" % [DAY_NAMES[weekday_index()], time_string(), period]


# Altura del sol en grados: 0 = amanecer (06:00), 90 = mediodía, 180 = atardecer (18:00).
func sun_elevation_deg():
	return clamp((hour() - 6.0) / 12.0, 0.0, 1.0) * 180.0


# 0 = noche cerrada, 1 = pleno día (con transición suave en el amanecer y atardecer)
func daylight():
	var h = hour()
	if h < 5.5 or h > 18.5:
		return 0.0
	if h < 7.0:
		return (h - 5.5) / 1.5
	if h > 17.0:
		return (18.5 - h) / 1.5
	return 1.0
