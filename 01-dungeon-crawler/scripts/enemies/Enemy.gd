extends CharacterBody2D

const SPEED := 40.0
var direction := Vector2.ZERO
var move_timer := 0.0

func _ready() -> void:
	z_index = 10
	pick_random_direction()

func _physics_process(delta: float) -> void:
	move_timer -= delta
	if move_timer <= 0:
		pick_random_direction()
	
	velocity = direction * SPEED
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		pick_random_direction()

func pick_random_direction() -> void:
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle))
	move_timer = randf_range(1.0, 3.0)
