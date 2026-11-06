extends Node
# Autoload "Stats": dinero, experiencia, nivel y guardado local del progreso.

signal changed
signal leveled_up(new_level)

const SAVE_PATH = "user://escuela_save.json"

var money = 0
var xp = 0
var level = 1
var study = 0


func xp_needed():
	return 40 + level * 30


func max_health():
	return 100.0 + (level - 1) * 15.0


func attack_damage():
	return 20.0 + (level - 1) * 3.0


func add_money(n):
	money = max(0, money + int(n))
	emit_signal("changed")


func add_xp(n):
	xp += int(n)
	while xp >= xp_needed():
		xp -= xp_needed()
		level += 1
		emit_signal("leveled_up", level)
		get_tree().call_group("hud", "toast", "¡Subiste al nivel %d!" % level)
	emit_signal("changed")


func add_study(n):
	study += int(n)
	emit_signal("changed")


func to_dict():
	return {"money": money, "xp": xp, "level": level, "study": study}


func from_dict(d):
	money = int(d.get("money", 0))
	xp = int(d.get("xp", 0))
	level = max(1, int(d.get("level", 1)))
	study = int(d.get("study", 0))
	emit_signal("changed")


func save_game():
	var f = File.new()
	if f.open(SAVE_PATH, File.WRITE) != OK:
		return
	f.store_string(to_json({"stats": to_dict(), "quests": Quests.to_dict()}))
	f.close()


func load_game():
	var f = File.new()
	if not f.file_exists(SAVE_PATH):
		return
	if f.open(SAVE_PATH, File.READ) != OK:
		return
	var res = JSON.parse(f.get_as_text())
	f.close()
	if res.error != OK or typeof(res.result) != TYPE_DICTIONARY:
		return
	from_dict(res.result.get("stats", {}))
	Quests.from_dict(res.result.get("quests", {}))


func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
