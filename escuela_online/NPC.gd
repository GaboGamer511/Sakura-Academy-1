extends StaticBody
# Personaje no jugable: da misiones y conversa. Se interactúa con [E].

const Avatar = preload("res://Avatar.gd")

var npc_id = ""
var npc_name = "NPC"
var model_path = ""
var color = Color(0.9, 0.5, 0.5)
var idle_lines = ["..."]
var yaw = 0.0
var plate_height = 2.3

var avatar
var _line_i = 0


func _ready():
	add_to_group("npc")
	add_to_group("plate")

	var col = CollisionShape.new()
	var cap = CapsuleShape.new()
	cap.radius = 0.45
	cap.height = 1.0
	col.shape = cap
	col.rotation_degrees = Vector3(90, 0, 0)
	col.translation = Vector3(0, 0.9, 0)
	add_child(col)

	avatar = Avatar.new()
	avatar.tint_strength = 0.55
	avatar.setup(model_path, color)
	avatar.rotation.y = yaw
	add_child(avatar)


func get_plate_text():
	var t = npc_name
	if Quests.available_for(npc_id) != "":
		t += "  [!]"
	return t


func interact():
	var text = Quests.talk(npc_id)
	if text == "":
		text = idle_lines[_line_i % idle_lines.size()]
		_line_i += 1
	get_tree().call_group("hud", "show_dialogue", npc_name, text)
