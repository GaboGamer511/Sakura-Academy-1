extends Area
export(String) var item_name = "Insignia Sakura"
export(String) var description = "Una pequeña insignia con el emblema de la academia."
var player_near = false
func _ready():
	add_to_group("interactable")
	connect("body_entered", self, "_on_enter")
	connect("body_exited", self, "_on_exit")
func interact(actor):
	actor.add_item(item_name)
	GameManager.collectibles += 1
	GameManager.improve_atmosphere(2)
	get_tree().call_group("hud", "item_collected", item_name, description)
	queue_free()
func _on_enter(body):
	if body.name == "Player": player_near = true
func _on_exit(body):
	if body.name == "Player": player_near = false
