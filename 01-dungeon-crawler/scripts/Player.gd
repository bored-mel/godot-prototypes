extends CharacterBody2D

const SPEED := 200.0

var generator: Node

func _ready() -> void:
	await get_tree().process_frame
	generator = get_tree().get_first_node_in_group("dungeon_generator")
	

func spawn_at(pos: Vector2) -> void:
	global_position = pos

func _physics_process(_delta: float) -> void:
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	
	velocity = input.normalized() * SPEED
	move_and_slide()
	
	if not generator:
		generator = get_tree().get_first_node_in_group("dungeon_generator")
		return
	
	if global_position.distance_to(generator.get_stairs_position()) < 16.0:
		generator.next_floor()
