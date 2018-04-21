extends Node2D

func _ready():
	
#	$TileMap.set_cell(0,0,$TileMap.tile_set.find_tile_by_name("redtile"))
	set_process(true)
	
func _process(delta):
	check_for_win_condition()
	
#Check if our player's tile map matches victory conditions
func check_for_win_condition():
	for cell in $VictoryTileMap.get_used_cells():
		if $ActiveTileMap.get_cell(cell[0], cell[1])  != $VictoryTileMap.get_cell(cell[0], cell[1]):
			return false
			
	return true;
		
		
