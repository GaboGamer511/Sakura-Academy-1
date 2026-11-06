extends SceneTree
# Carga cada GDScript del proyecto para detectar errores de parseo y preload roto.
# Ejecutar: godot --headless --path . --script res://tests/validate_scripts.gd

var checked = 0
var failures = []


func _init():
	call_deferred("_run_validation")


func _run_validation():
	_scan("res://")
	if failures.size() > 0:
		for failure in failures:
			push_error(failure)
		print("SCRIPT_VALIDATION_FAILED=%d" % failures.size())
		quit(1)
		return
	print("SCRIPT_VALIDATION_OK=%d" % checked)
	quit(0)


func _scan(path):
	var directory = Directory.new()
	var error = directory.open(path)
	if error != OK:
		failures.append("No se pudo abrir el directorio: " + path)
		return
	directory.list_dir_begin(true, true)
	var entry = directory.get_next()
	while entry != "":
		if directory.current_is_dir():
			if entry != ".import" and entry != ".git":
				_scan(path.plus_file(entry))
		elif entry.to_lower().ends_with(".gd"):
			var script_path = path.plus_file(entry)
			var resource = load(script_path)
			checked += 1
			if resource == null:
				failures.append("No se pudo cargar: " + script_path)
		entry = directory.get_next()
	directory.list_dir_end()
