extends Label

func _ready() -> void:
	var generator = get_tree().get_first_node_in_group("dungeon_generator")
	generator.dungeon_generated.connect(_on_dungeon_generated)

func _on_dungeon_generated(floor_num: int) -> void:
	text = "Floor: " + str(floor_num)
