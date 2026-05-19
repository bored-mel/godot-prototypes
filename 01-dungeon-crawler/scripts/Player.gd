extends CharacterBody2D

const SPEED := 200.0

func spawn_at(pos: Vector2) -> void:
	global_position = pos
	
func _physics_process(_delta: float) -> void:
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	
	velocity = input.normalized() * SPEED
	
	move_and_slide()
