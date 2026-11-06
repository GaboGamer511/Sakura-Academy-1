tool
extends Spatial

enum Gender { FEMALE, MALE }
export(Gender) var gender = Gender.FEMALE
export(int) var social_group = 0
export(float, 0.85, 1.15, 0.01) var height_scale = 1.0
export(float, 0.85, 1.15, 0.01) var build_scale = 1.0
export(Color) var custom_eye_color = Color(0.30, 0.13, 0.75, 1.0)

var model_instance = null
var animation_player = null
var current_animation = ""
var _last_animation_refresh = 0.0

func _ready():
    if has_node("CharacterModel"):
        model_instance = get_node("CharacterModel")
    else:
        _rebuild_model()
    if Engine.editor_hint and is_instance_valid(model_instance):
        _assign_preview_owner(model_instance, get_tree().edited_scene_root)
    _find_animation_player()
    _play_animation("Idle")

func set_appearance(group_id, gender_id, height_value = 1.0, build_value = 1.0):
    social_group = group_id
    gender = gender_id
    height_scale = height_value
    build_scale = build_value
    _rebuild_model()
    _find_animation_player()
    _play_animation("Idle")

func _is_player_character():
    return get_parent() != null and get_parent().name == "Player"

func _select_model():
    # No sustituir el modelo articulado por las antiguas mallas geométricas.
    # El instalador coloca el modelo humano riggeado en esta ruta.
    var rigged_schoolkid = "res://models/characters/Schoolkid.glb"
    if ResourceLoader.exists(rigged_schoolkid):
        return rigged_schoolkid
    return ""

func _rebuild_model():
    if is_instance_valid(model_instance):
        model_instance.queue_free()
        model_instance = null
    var path = _select_model()
    if path == "":
        # El HUD muestra una única advertencia global; evitar 15 warnings repetidos.
        animation_player = null
        current_animation = ""
        return
    var packed = load(path)
    if packed is PackedScene:
        model_instance = packed.instance()
        model_instance.name = "CharacterModel_RiggedGLB"
        model_instance.scale = Vector3(build_scale, height_scale, build_scale)
        add_child(model_instance)
        if Engine.editor_hint:
            _assign_preview_owner(model_instance, get_tree().edited_scene_root)
    else:
        push_warning("No se pudo importar el personaje GLB articulado: " + path)
        model_instance = null
    animation_player = null
    current_animation = ""

func _find_animation_player():
    animation_player = _find_animation_player_recursive(model_instance)

func _find_animation_player_recursive(node):
    if node == null:
        return null
    if node is AnimationPlayer:
        return node
    for child in node.get_children():
        var found = _find_animation_player_recursive(child)
        if found != null:
            return found
    return null

func _play_animation(wanted):
    if animation_player == null:
        return
    var wanted_lower = wanted.to_lower()
    for animation_name in animation_player.get_animation_list():
        if animation_name.to_lower().find(wanted_lower) >= 0:
            if current_animation != animation_name:
                animation_player.play(animation_name)
                current_animation = animation_name
            return
    if current_animation == "" and animation_player.get_animation_list().size() > 0:
        current_animation = animation_player.get_animation_list()[0]
        animation_player.play(current_animation)

func _process(_delta):
    if Engine.editor_hint or not is_instance_valid(model_instance):
        return
    var parent_body = get_parent()
    var speed = 0.0
    if parent_body:
        var parent_velocity = parent_body.get("velocity")
        if typeof(parent_velocity) == TYPE_VECTOR3:
            speed = Vector2(parent_velocity.x, parent_velocity.z).length()
    if speed > 5.0:
        _play_animation("Run")
    elif speed > 0.2:
        _play_animation("Walk")
    else:
        _play_animation("Idle")

func _assign_preview_owner(node, scene_owner):
    if node == null or scene_owner == null:
        return
    node.owner = scene_owner
    for child in node.get_children():
        _assign_preview_owner(child, scene_owner)
