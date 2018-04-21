extends Node2D

var victoryDoorOpen = false
var nextLevel = "level3"

func _ready():
	set_process(true)
	
func next_level(binds):
	global.goto_scene("res://levels/"+nextLevel+".tscn")
	
func _process(delta):
	if(!victoryDoorOpen && check_for_win_condition()):
		open_victory_door()

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

func open_victory_door():
	victoryDoorOpen = true
	$ActiveTileMap.set_cell(7, 0, $ActiveTileMap.tile_set.find_tile_by_name("dooropen_left"))
	$ActiveTileMap.set_cell(8, 0, $ActiveTileMap.tile_set.find_tile_by_name("dooropen_right"))
	get_owner().get_node("Walls/DoorWall/CollisionShape2D").disabled = true
	$Area2D.connect("body_entered", self, "next_level", [], CONNECT_ONESHOT)
	
