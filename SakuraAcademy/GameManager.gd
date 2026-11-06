extends Node
var player_sanity = 100.0
var school_atmosphere = 100.0
var is_bloody = false
var police_called = false
var police_timer = 0.0
var students_talked = 0
var collectibles = 0
var talked_students = []
signal stats_changed
func _process(delta):
	if police_called:
		police_timer += delta
		if police_timer >= 12.0:
			get_tree().call_group("hud", "show_arrest")
func trigger_police_alert():
	if not police_called:
		police_called = true
		police_timer = 0.0
func register_student_talk(student_name):
	if not talked_students.has(student_name):
		talked_students.append(student_name)
		students_talked = talked_students.size()
func improve_atmosphere(amount):
	school_atmosphere = clamp(school_atmosphere + amount, 0, 100)
	emit_signal("stats_changed")
func reset_game():
	player_sanity = 100.0
	school_atmosphere = 100.0
	is_bloody = false
	police_called = false
	police_timer = 0.0
	students_talked = 0
	collectibles = 0
	talked_students.clear()
