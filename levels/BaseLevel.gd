extends Node2D

var victoryDoorOpen = false

onready var enemy1 = preload("res://characters/Enemy1.tscn")
onready var clawer = preload("res://characters/Clawer.tscn")
onready var scorpion = preload("res://characters/Scorpion.tscn")


func _enter_tree():
	global.clear_leftover_enemies()

func _ready():
	set_process(true)
	build_hint_tile_map()
	
	# TODO - make this more like an AI director
	get_owner().get_node("SpawnTimer").connect("timeout", self, "spawn_base_enemy")
	
	
#builds the hint tile map so playuer knows where to put colors
func build_hint_tile_map():
	for cell in $VictoryTileMap.get_used_cells():
		#MY EYES, THEY BLEED
		$HintTileMap.set_cell(cell.x, cell.y, $HintTileMap.tile_set.find_tile_by_name($HintTileMap.tile_set.tile_get_name($VictoryTileMap.get_cell(cell[0], cell[1])) + "hint"))
	
func next_level(binds):
	global.playerHealth = get_tree().get_nodes_in_group("player")[0].health
	var nextLevel = get_owner().get_node("NextLevel").nextLevel
	global.goto_scene("res://levels/"+nextLevel+".tscn")
	
func _process(delta):
	if(!victoryDoorOpen && check_for_win_condition()):
		open_victory_door()

# gets the tile coords based on game coords
func get_tile_coords_by_game_coords(x,y):
	return Vector2(int(x/$ActiveTileMap.cell_size.x), int(y/$ActiveTileMap.cell_size.y))

func convert_tile_coords_to_game_coords(x,y):
	return Vector2(int(x*$ActiveTileMap.cell_size.x)+int($ActiveTileMap.cell_size.x/2), int(y*$ActiveTileMap.cell_size.y)+int($ActiveTileMap.cell_size.y/2))

#converts the tile at this position to the specified color
func convert_tile_to_color(x,y,color):
	var tile = get_tile_coords_by_game_coords(x,y)
	$ActiveTileMap.set_cell(tile.x, tile.y, $ActiveTileMap.tile_set.find_tile_by_name(color+"tile"))

func clear_tile(x,y):
	var tile = get_tile_coords_by_game_coords(x,y)
	$ActiveTileMap.set_cell(tile.x, tile.y, -1)

#Check if our player's tile map matches victory conditions
func check_for_win_condition():
	for cell in $VictoryTileMap.get_used_cells():
		if $ActiveTileMap.get_cell(cell[0], cell[1])  != $VictoryTileMap.get_cell(cell[0], cell[1]):
			return false
			
	return true;

# x and y are map positions not game position
func find_closest_used_tile(x, y):
	var positionVector = Vector2(x,y)
	var closestCell = null
	var closestCellDistance = -1
	
	for cell in $ActiveTileMap.get_used_cells():
		var diffVector = positionVector - cell
		if(closestCellDistance < 0 || diffVector.length() < closestCellDistance):
			closestCell = cell
			closestCellDistance = diffVector.length()
	
	return closestCell

func open_victory_door():
	victoryDoorOpen = true
	$WhiteTileMap.set_cell(7, 0, $WhiteTileMap.tile_set.find_tile_by_name("dooropen_left"))
	$WhiteTileMap.set_cell(8, 0, $WhiteTileMap.tile_set.find_tile_by_name("dooropen_right"))
	get_owner().get_node("Walls/DoorWall/CollisionShape2D").disabled = true
	$Area2D.connect("body_entered", self, "next_level", [], CONNECT_ONESHOT)
	
func spawn_base_enemy():
	var spawns = get_tree().get_nodes_in_group("spawn")
	if(spawns.size() > 0):
		var spawn = spawns[rand_range(0, spawns.size()-1)]
		var newEnemy = enemy1.instance()
		newEnemy.position = spawn.position
		get_tree().get_root().add_child(newEnemy)
	