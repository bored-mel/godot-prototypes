extends Control

const TILE_SIZE := 2
const WALL_COLOR := Color(0.3, 0.3, 0.3)
const FLOOR_COLOR := Color(0.15, 0.15, 0.15)
const PLAYER_COLOR := Color(0.2, 0.8, 0.2)

var tilemap: TileMapLayer
var player: CharacterBody2D

func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("dungeon_map")
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0.7))
	
	for cell in tilemap.get_used_cells():
		var atlas_coords = tilemap.get_cell_atlas_coords(cell)
		var color = FLOOR_COLOR if atlas_coords == Vector2i(0, 0) else WALL_COLOR
		draw_rect(Rect2(Vector2(cell) * TILE_SIZE, Vector2.ONE * TILE_SIZE), color)
	
	var player_tile = Vector2(player.global_position / 16.0) * TILE_SIZE
	draw_circle(player_tile, 3.0, PLAYER_COLOR)
