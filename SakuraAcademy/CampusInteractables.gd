tool
extends Spatial
const ITEM_SCRIPT = preload("res://CampusItem.gd")
var items_root = null
func _ready():
	if has_node("_ItemsPreviewGenerated"):
		items_root = get_node("_ItemsPreviewGenerated")
		for old_item in items_root.get_children():
			old_item.free()
	else:
		items_root = Spatial.new()
		items_root.name = "_ItemsPreviewGenerated"
		add_child(items_root)
	_make_item("Insignia Sakura", "Una insignia esmaltada con el emblema de la academia.", Vector3(2.5,0.8,4), Color(0.91,0.57,0.72))
	_make_item("Tarjeta de biblioteca", "Una tarjeta para acceder a la biblioteca.", Vector3(-22,0.8,14.5), Color(0.55,0.76,0.91))
	_make_item("Guía de clubes", "El calendario de actividades de los clubes escolares.", Vector3(0,0.8,17.5), Color(0.87,0.76,0.48))
	if Engine.editor_hint:
		_assign_preview_owner(items_root, get_tree().edited_scene_root)
func _make_item(item_name, description, pos, color):
	var item = Area.new()
	item.name = item_name.replace(" ","")
	item.translation = pos
	item.set_script(ITEM_SCRIPT)
	item.set("item_name", item_name)
	item.set("description", description)
	var sphere = SphereShape.new()
	sphere.radius = 1.1
	var collision = CollisionShape.new()
	collision.shape = sphere
	item.add_child(collision)
	var mesh = MeshInstance.new()
	var visual = SphereMesh.new()
	visual.radius = 0.22
	visual.height = 0.44
	mesh.mesh = visual
	var mat = SpatialMaterial.new()
	mat.albedo_color = color
	mat.emission_enabled = true
	mat.emission = color
	mat.emission_energy = 0.22
	mesh.material_override = mat
	item.add_child(mesh)
	items_root.add_child(item)


func _assign_preview_owner(node, scene_owner):
	if node == null or scene_owner == null:
		return
	node.owner = scene_owner
	for child in node.get_children():
		_assign_preview_owner(child, scene_owner)
