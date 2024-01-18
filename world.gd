extends Node2D

# Reference to the TileMap
@onready var tilemap : TileMap = $Ground/TileMap
@onready var player = $Player

@export var slime_trail: PackedScene

# Reference to the two tilesets
var tile_set_base : TileSet
var tile_set_slime : TileSet
var slime_left : RayCast2D
var slime_right : RayCast2D
var slime_bottom : RayCast2D

func _ready():
	# Set the initial tileset for the entire TileMap
	#tile_set_base = tilemap.tile_set["Base"]
	#tile_set_slime = tilemap.tile_set["Slime"]
	slime_left = get_node("Player/LeftSlime")
	slime_right = get_node("Player/RightSlime")
	slime_bottom = get_node("Player/BottomSlime")

func _process(delta):
	spawn_slime()

# Swap the appearance of the tile at the specified coordinates
func spawn_slime():
	if slime_left.is_colliding():
		var player_tile_coords : Vector2
		player_tile_coords = tilemap.local_to_map(slime_left.get_collision_point())
		var slime = slime_trail.instantiate()
		add_child(slime)
		slime.transform = player.global_transform
	
	if slime_right.is_colliding():
		var player_tile_coords : Vector2
		player_tile_coords = tilemap.local_to_map(slime_right.get_collision_point())
		var slime = slime_trail.instantiate()
		add_child(slime)
		slime.transform = player.global_transform
	
	if slime_bottom.is_colliding():
		var player_tile_coords : Vector2
		player_tile_coords = tilemap.local_to_map(slime_bottom.get_collision_point())
		var slime = slime_trail.instantiate()
		add_child(slime)
		slime.transform = player.global_transform
	
	# Get the current tile ID at the specified coordinates
	#var current_tile_id : int = tilemap.get_cell(tile_coords.x, tile_coords.y)
	# Check the current tile ID and update it based on the condition
	#if current_tile_id == tile_set_base:
		#tilemap.set_cell(tile_coords.x, tile_coords.y, tileID_tileset2)
	#elif current_tile_id == tileID_tileset2:
		#tilemap.set_cell(tile_coords.x, tile_coords.y, tileID_tileset1)
	# Add more conditions if you have more than two tilesets
