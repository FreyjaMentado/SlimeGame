#extends Node2D
#
## Reference to the TileMap
#@onready var tilemap : TileMap = $Ground/TileMap
#
## Reference to the two tilesets
#var tile_set_base : TileSet
#var tile_set_slime : TileSet
#var player_bottom_offset : float = 16.0
#
#func _ready():
	## Set the initial tileset for the entire TileMap
	#tile_set_base = tilemap.tile_set["Base"]
	#tile_set_slime = tilemap.tile_set["Slime"]
#
#func _process(delta):
	## Get the player's tile coordinates
	#var player_tile_coords : Vector2 = tilemap.world_to_map($Player.global_position)
#
	## Check the condition to determine when to swap the tile
	#if should_swap_tile(player_tile_coords):
		## Swap the appearance of the tile at the player's coordinates
		#swap_tile(player_tile_coords)
#
## Swap the appearance of the tile at the specified coordinates
#func swap_tile(tile_coords: Vector2):
	## Get the current tile ID at the specified coordinates
	#var current_tile_id : int = tilemap.get_cell(tile_coords.x, tile_coords.y)
#
	## Check the current tile ID and update it based on the condition
	#if current_tile_id == tileID_tileset1:
		#tilemap.set_cell(tile_coords.x, tile_coords.y, tileID_tileset2)
	#elif current_tile_id == tileID_tileset2:
		#tilemap.set_cell(tile_coords.x, tile_coords.y, tileID_tileset1)
	## Add more conditions if you have more than two tilesets
