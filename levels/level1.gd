extends Node2D

func _ready():
	
#	$TileMap.set_cell(0,0,$TileMap.tile_set.find_tile_by_name("redtile"))
	set_process(true)
	
func _process(delta):
	check_for_win_condition()

# gets the tile coords based on game coords
func get_tile_coords_by_game_coords(x,y):
	return Vector2(round(x/$ActiveTileMap.cell_size.x), round(y/$ActiveTileMap.cell_size.y))
	
#converts the tile at this position to the specified color
func convert_tile_to_color(x,y,color):
	var tile = get_tile_coords_by_game_coords(x,y)
	$ActiveTileMap.set_cell(tile.x, tile.y, $ActiveTileMap.tile_set.find_tile_by_name(color+"tile"))

#Check if our player's tile map matches victory conditions
func check_for_win_condition():
	for cell in $VictoryTileMap.get_used_cells():
		if $ActiveTileMap.get_cell(cell[0], cell[1])  != $VictoryTileMap.get_cell(cell[0], cell[1]):
			return false
			
	return true;
		
		
