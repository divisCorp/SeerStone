extends CharacterBody2D

@export var speed: float = 250.0
@export var faith: float = 40.0

@onready var interaction_ray: RayCast2D = $InteractionRay

var touch_start_pos: Vector2
var is_dragging: bool = false

func _physics_process(delta: float) -> void:
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = direction * speed
    move_and_slide()

    if direction != Vector2.ZERO:
        interaction_ray.target_position = direction.normalized() * 80

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            touch_start_pos = event.position
            is_dragging = true
        else:
            is_dragging = false
            # Tap to interact
            try_interact()

    if event is InputEventScreenDrag and is_dragging:
        var drag_direction = (event.position - touch_start_pos).normalized()
        velocity = drag_direction * speed * 1.5
        move_and_slide()

func try_interact() -> void:
    interaction_ray.force_raycast_update()
    if interaction_ray.is_colliding():
        var target = interaction_ray.get_collider()
        if target and target.has_method("on_interact"):
            target.on_interact(self)

func adjust_faith(amount: float) -> void:
    faith = clamp(faith + amount, 0, 100)
    print("Faith:", faith)