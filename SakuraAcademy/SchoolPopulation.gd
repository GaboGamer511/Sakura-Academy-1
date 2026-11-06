tool
extends Spatial
const STUDENT_SCRIPT = preload("res://student.gd")
const VISUAL_SCRIPT = preload("res://CharacterVisual.gd")
var population_root = null
var roster = [
["Aiko Tanaka",1,0,Vector3(0,0,-23)], ["Ren Sato",2,1,Vector3(8,0,6)],
["Yuna Mori",3,0,Vector3(-13,0,-11)], ["Daichi Kato",4,1,Vector3(13,0,-10)],
["Sora Fujimoto",5,0,Vector3(-5,0,15)], ["Kaito Nakamura",0,1,Vector3(0,0,-34)],
["Mei Kobayashi",1,0,Vector3(-15,0,8)], ["Haru Ito",0,1,Vector3(15,0,8)],
["Rika Suzuki",3,0,Vector3(-10,0,-3)], ["Takumi Abe",4,1,Vector3(10,0,-3)],
["Emi Hayashi",5,0,Vector3(-4,0,-12)], ["Shin Watanabe",2,1,Vector3(4,0,-12)],
["Noa Ishikawa",0,0,Vector3(-18,0,17)], ["Yuto Yamamoto",0,1,Vector3(18,0,17)]
]
func _ready():
	if has_node("_StudentsPreviewGenerated"):
		population_root = get_node("_StudentsPreviewGenerated")
		for old_student in population_root.get_children():
			old_student.free()
	else:
		population_root = Spatial.new()
		population_root.name = "_StudentsPreviewGenerated"
		add_child(population_root)
	for entry in roster:
		_make_student(entry)
	if Engine.editor_hint:
		_assign_preview_owner(population_root, get_tree().edited_scene_root)
func _make_student(data):
	var student = KinematicBody.new()
	student.name = str(data[0]).replace(" ", "")
	student.translation = data[3]
	student.set_script(STUDENT_SCRIPT)
	student.set("student_name", data[0])
	student.set("social_group", data[1])
	student.set("gender", data[2])
	student.set("speed", rand_range(1.15,1.75))
	var capsule = CapsuleShape.new()
	capsule.radius = 0.34
	capsule.height = 1.8
	var col = CollisionShape.new()
	col.shape = capsule
	col.translation = Vector3(0,0.9,0)
	student.add_child(col)
	var visual = Spatial.new()
	visual.name = "CharacterVisual"
	visual.translation = Vector3(0,0,0)
	visual.set_script(VISUAL_SCRIPT)
	visual.set("social_group", data[1])
	visual.set("gender", data[2])
	student.add_child(visual)
	population_root.add_child(student)


func _assign_preview_owner(node, scene_owner):
	if node == null or scene_owner == null:
		return
	node.owner = scene_owner
	for child in node.get_children():
		_assign_preview_owner(child, scene_owner)
