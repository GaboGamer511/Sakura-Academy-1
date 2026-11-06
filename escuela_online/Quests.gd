extends Node
# Autoload "Quests": misiones por jugador (cada cliente lleva las suyas).
# Tipos de objetivo: zone (entrar a una zona), study (segundos de estudio),
# collect (recoger objetos), kill (derrotar enemigos).

signal changed

const ORDER = ["q1", "q2", "q3", "q4", "q5"]

const QUESTS = {
	"q1": {
		"title": "Bienvenido a la escuela",
		"giver": "sato", "requires": "",
		"intro": "¡Bienvenido a la Preparatoria Sakura! Tu primer día: entra a un aula del edificio y busca tu lugar.",
		"remind": "Las aulas están dentro del edificio, a los lados del pasillo.",
		"objectives": [{"type": "zone", "target": "aula", "count": 1, "text": "Entra a un aula"}],
		"money": 50, "xp": 20
	},
	"q2": {
		"title": "Atención en clase",
		"giver": "sato", "requires": "q1",
		"intro": "Muy bien. Ahora quédate en el aula durante el horario de clases (8:00 a 12:30 y 13:30 a 15:00) y presta atención.",
		"remind": "Tienes que estar dentro de un aula mientras sea hora de clases.",
		"objectives": [{"type": "study", "target": "aula", "count": 60, "text": "Estudiar en el aula (segundos)"}],
		"money": 120, "xp": 60
	},
	"q3": {
		"title": "Libros perdidos",
		"giver": "mika", "requires": "",
		"intro": "¡Ay, se me perdieron libros de la biblioteca por toda la escuela! ¿Me traes 5? Brillan en azul.",
		"remind": "Busca libros brillantes en el patio, el pasillo y cerca del dojo.",
		"objectives": [{"type": "collect", "target": "book", "count": 5, "text": "Recoger libros perdidos"}],
		"money": 100, "xp": 40
	},
	"q4": {
		"title": "Prueba del club de kendo",
		"giver": "takeda", "requires": "",
		"intro": "¿Quieres entrar al club? Demuestra tu técnica: derrota 3 muñecos en el dojo. Clic izquierdo ataca y Espacio esquiva.",
		"remind": "Los muñecos están en el dojo, a la derecha del edificio. Cuida tu stamina.",
		"objectives": [{"type": "kill", "target": "dummy", "count": 3, "text": "Derrotar muñecos de entrenamiento"}],
		"money": 150, "xp": 80
	},
	"q5": {
		"title": "El rival del patio oeste",
		"giver": "takeda", "requires": "q4",
		"intro": "Kurogane, líder del club rival, desafía a todos en el patio oeste. Véncelo. ¡Esquiva cuando levante la espada!",
		"remind": "Kurogane está en la arena de piedra, al oeste del edificio.",
		"objectives": [{"type": "kill", "target": "rival", "count": 1, "text": "Derrotar a Kurogane"}],
		"money": 400, "xp": 200
	}
}

var active = {}      # id -> [progreso por objetivo]
var done = []


func _ready():
	Stats.load_game()


func is_active(id):
	return active.has(id)


func is_done(id):
	return done.has(id)


# Primera misión que este NPC puede ofrecer ahora mismo ("" si ninguna).
func available_for(giver):
	for id in ORDER:
		var q = QUESTS[id]
		if q.giver != giver or active.has(id) or done.has(id):
			continue
		if q.requires != "" and not done.has(q.requires):
			continue
		return id
	return ""


func has_active_from(giver):
	for id in active:
		if QUESTS[id].giver == giver:
			return id
	return ""


func start(id):
	var q = QUESTS[id]
	var prog = []
	for o in q.objectives:
		prog.append(0)
	active[id] = prog
	get_tree().call_group("hud", "toast", "Nueva misión: " + q.title)
	emit_signal("changed")


# Devuelve el texto que debe decir el NPC (o "" si no tiene nada especial).
func talk(giver):
	var id = available_for(giver)
	if id != "":
		start(id)
		return QUESTS[id].intro
	id = has_active_from(giver)
	if id != "":
		return QUESTS[id].remind
	return ""


func notify(type, target, amount = 1):
	var finished = []
	for id in active:
		var q = QUESTS[id]
		var prog = active[id]
		var all_done = true
		for i in range(q.objectives.size()):
			var o = q.objectives[i]
			if o.type == type and o.target == target and prog[i] < o.count:
				prog[i] = min(o.count, prog[i] + amount)
			if prog[i] < o.count:
				all_done = false
		if all_done:
			finished.append(id)
	for id in finished:
		_complete(id)
	emit_signal("changed")


func _complete(id):
	var q = QUESTS[id]
	active.erase(id)
	if not done.has(id):
		done.append(id)
	Stats.add_money(q.money)
	Stats.add_xp(q.xp)
	get_tree().call_group("hud", "toast", "Misión completada: %s  (+¥%d, +%d XP)" % [q.title, q.money, q.xp])
	emit_signal("changed")


func tracker_text():
	if active.empty():
		return "Sin misiones activas.\nHabla con la profesora Sato\n(pasillo del edificio) con [E]."
	var t = ""
	for id in active:
		var q = QUESTS[id]
		t += q.title + "\n"
		for i in range(q.objectives.size()):
			var o = q.objectives[i]
			t += "  - %s: %d/%d\n" % [o.text, active[id][i], o.count]
	return t


func to_dict():
	return {"active": active, "done": done}


func from_dict(d):
	active = {}
	var a = d.get("active", {})
	for id in a:
		if QUESTS.has(id):
			var prog = []
			for v in a[id]:
				prog.append(int(v))
			while prog.size() < QUESTS[id].objectives.size():
				prog.append(0)
			active[id] = prog
	done = []
	for id in d.get("done", []):
		if QUESTS.has(id):
			done.append(id)
	emit_signal("changed")
