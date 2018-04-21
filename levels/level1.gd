extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
#	$TileMap.set_cell(0,0,$TileMap.tile_set.find_tile_by_name("redtile"))
	print(check_for_win_condition())
	
#Check if our player's tile map matches victory conditions
func check_for_win_condition():
	for cell in $VictoryTileMap.get_used_cells():
		if $ActiveTileMap.get_cell(cell[0], cell[1])  != $VictoryTileMap.get_cell(cell[0], cell[1]):
			return false
			
	return true;
		
		
