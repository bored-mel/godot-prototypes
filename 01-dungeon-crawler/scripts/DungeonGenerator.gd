extends Node

const ROOM_MIN_SIZE := 5
const ROOM_MAX_SIZE := 10
const ROOM_COUNT := 6
const MAP_WIDTH := 80
const MAP_HEIGHT := 60

const FLOOR_TILE := Vector2i(0, 0)
const WALL_TILE := Vector2i(1, 0)

var rooms: Array[Rect2i] = []
var tilemap: TileMapLayer

var player: CharacterBody2D
var stairs_position := Vector2.ZERO
var floor_number := 1

var enemy_scene := preload("res://scenes/Enemy.tscn")
var enemies_node: Node

signal dungeon_generated(floor_num: int)


func _ready() -> void:
	tilemap = get_parent().get_node("DungeonMap")
	player = get_parent().get_node("Player")
	
	enemies_node = Node.new()
	enemies_node.name = "Enemies"
	get_parent().call_deferred("add_child", enemies_node)
	
	await get_tree().process_frame
	generate_new_floor()


func generate_new_floor() -> void:
	rooms.clear()
	clear_enemies()
	generate()
	
	var first_room_center = rooms[0].get_center()
	player.spawn_at(Vector2(first_room_center) * 16.0)
	
	var last_room = rooms[rooms.size() - 1]
	var stairs_tile = last_room.get_center()
	stairs_position = Vector2(stairs_tile) * 16.0 + Vector2(8, 8)
	
	spawn_enemies()
	dungeon_generated.emit(floor_number)

func clear_enemies() -> void:
	for enemy in enemies_node.get_children():
		enemy.queue_free()

func spawn_enemies() -> void:
	for i in range(1, rooms.size() - 1):
		var room = rooms[i]
		var enemy_count = randi_range(1, 3)
		for j in enemy_count:
			var enemy = enemy_scene.instantiate()
			var rand_x = randf_range(room.position.x + 1, room.end.x - 1)
			var rand_y = randf_range(room.position.y + 1, room.end.y - 1)
			enemy.global_position = Vector2(rand_x, rand_y) * 16.0
			enemies_node.add_child(enemy)
			print("Enemy parent: ", enemy.get_parent().name)
			print("Enemy visible: ", enemy.visible)
			print("Enemy in tree: ", enemy.is_inside_tree())
			print("Enemy spawned at: ", enemy.global_position)
	print("Total enemies: ", enemies_node.get_child_count())
	
	
	
func generate() -> void:
	fill_with_walls()
	place_rooms()
	connect_rooms()

func get_stairs_position() -> Vector2:
	return stairs_position

func next_floor() -> void:
	floor_number += 1
	generate_new_floor()
	
func fill_with_walls() -> void:
	for x in MAP_WIDTH:
		for y in MAP_HEIGHT:
			tilemap.set_cell(Vector2i(x, y), 0, WALL_TILE)

func place_rooms() -> void:
	for i in ROOM_COUNT:
		var w := randi_range(ROOM_MIN_SIZE, ROOM_MAX_SIZE)
		var h := randi_range(ROOM_MIN_SIZE, ROOM_MAX_SIZE)
		var x := randi_range(1, MAP_WIDTH - w - 1)
		var y := randi_range(1, MAP_HEIGHT - h - 1)
		var new_room := Rect2i(x, y, w, h)
		
		var overlaps := false
		for room in rooms:
			if room.grow(1).intersects(new_room):
				overlaps = true
				break
		
		if not overlaps:
			carve_room(new_room)
			rooms.append(new_room)

func carve_room(room: Rect2i) -> void:
	for x in range(room.position.x, room.end.x):
		for y in range(room.position.y, room.end.y):
			tilemap.set_cell(Vector2i(x, y), 0, FLOOR_TILE)

func connect_rooms() -> void:
	for i in range(1, rooms.size()):
		var prev_center := rooms[i - 1].get_center()
		var curr_center := rooms[i].get_center()
		carve_corridor(prev_center, curr_center)

func carve_corridor(from: Vector2i, to: Vector2i) -> void:
	var x := from.x
	var y := from.y
	
	while x != to.x:
		tilemap.set_cell(Vector2i(x, y), 0, FLOOR_TILE)
		x += sign(to.x - x)
	
	while y != to.y:
		tilemap.set_cell(Vector2i(x, y), 0, FLOOR_TILE)
		y += sign(to.y - y)
