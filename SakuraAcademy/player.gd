extends KinematicBody

export(float) var walk_speed = 4.2
export(float) var run_speed = 6.4
export(float) var jump_speed = 5.0
export(float) var gravity = 18.0
export(float) var mouse_sensitivity = 0.14

var velocity = Vector3.ZERO
var interaction_target = null
var equipped_item = ""
var quest_stage = 0
var reputation = 50
var inventory = []
var _camera_pitch = 0.349066

onready var camera_pivot = get_node_or_null("CameraPivot")
onready var camera = get_node_or_null("CameraPivot/Camera")
onready var visual = get_node_or_null("CharacterVisual")

func _ready():
    if camera:
        camera.current = true
        camera.make_current()
        camera.near = 0.05
        camera.far = 300.0
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    if camera:
        print("Sakura Academy | Cámara actual: ", camera.current, " | Posición inicial: ", camera.global_transform.origin, " | Rotación X: ", rad2deg(camera.rotation.x))
    else:
        push_error("Sakura Academy | Falta Player/CameraPivot/Camera en Main.tscn")

func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and camera_pivot and camera:
        camera_pivot.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
        _camera_pitch = clamp(_camera_pitch + deg2rad(event.relative.y * mouse_sensitivity), deg2rad(-35.0), deg2rad(65.0))
        camera.rotation.x = _camera_pitch
    if event is InputEventKey and event.pressed and not event.echo:
        if event.scancode == KEY_E:
            var hud = get_tree().get_root().find_node("HUD", true, false)
            if hud and is_instance_valid(hud.dialogue_panel) and hud.dialogue_panel.visible:
                hud.close_dialogue()
            else:
                interact()
        elif event.scancode == KEY_F:
            use_equipped()
        elif event.scancode == KEY_Q:
            _toggle_quest_hint()

func _physics_process(delta):
    var input_dir = Vector2.ZERO
    input_dir.x = (1.0 if Input.is_key_pressed(KEY_D) else 0.0) - (1.0 if Input.is_key_pressed(KEY_A) else 0.0)
    input_dir.y = (1.0 if Input.is_key_pressed(KEY_W) else 0.0) - (1.0 if Input.is_key_pressed(KEY_S) else 0.0)

    var forward = Vector3(0, 0, -1)
    var right = Vector3(1, 0, 0)
    if camera_pivot:
        var camera_basis = camera_pivot.global_transform.basis
        forward = -camera_basis.z
        right = camera_basis.x
    forward.y = 0.0
    right.y = 0.0
    forward = forward.normalized()
    right = right.normalized()
    var direction = (right * input_dir.x + forward * input_dir.y).normalized()

    var moving_fast = Input.is_key_pressed(KEY_SHIFT)
    var speed = run_speed if moving_fast else walk_speed
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

    if direction.length() > 0.1 and visual:
        var desired_yaw = atan2(-direction.x, -direction.z)
        visual.rotation.y = lerp_angle(visual.rotation.y, desired_yaw, min(1.0, delta * 10.0))

    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = -0.15
        if Input.is_action_just_pressed("ui_accept"):
            velocity.y = jump_speed
    velocity = move_and_slide(velocity, Vector3.UP)
    _find_interaction_target()

func _find_interaction_target():
    interaction_target = null
    var nearest = 2.5
    for node in get_tree().get_nodes_in_group("interactable"):
        if not is_instance_valid(node):
            continue
        var distance = global_transform.origin.distance_to(node.global_transform.origin)
        if distance < nearest:
            nearest = distance
            interaction_target = node

func interact():
    if interaction_target and interaction_target.has_method("interact"):
        interaction_target.interact(self)
    else:
        var npc = _nearest_student(2.8)
        if npc:
            npc.talk_to(self)
        else:
            get_tree().call_group("hud", "notify", "Acércate a un estudiante u objeto para interactuar.")

func _nearest_student(max_distance):
    var best = null
    var best_distance = max_distance
    for npc in get_tree().get_nodes_in_group("students"):
        if not is_instance_valid(npc):
            continue
        var distance = global_transform.origin.distance_to(npc.global_transform.origin)
        if distance < best_distance:
            best_distance = distance
            best = npc
    return best

func use_equipped():
    if equipped_item == "":
        get_tree().call_group("hud", "notify", "No tienes ningún objeto equipado.")
    else:
        get_tree().call_group("hud", "notify", "Has examinado: " + equipped_item)

func _toggle_quest_hint():
    get_tree().call_group("hud", "toggle_quest")

func add_item(item_name):
    inventory.append(item_name)
    equipped_item = item_name
    get_tree().call_group("hud", "notify", "Objeto obtenido: " + item_name)
