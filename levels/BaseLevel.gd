extends Node2D

var victoryDoorOpen = false
var spawnTimer

const tileGoodPointValue = 100
const tileBadPointValue = -20


func _enter_tree():
	global.clear_leftover_enemies()

func _ready():
	set_process(true)
	build_hint_tile_map()
	GameDirector.init_director(self)
	spawnTimer = get_owner().get_node("SpawnTimer")
	global.display_score()
	if global.shouldPlayMusic:
		get_owner().get_node("Music").play()
	

	
#builds the hint tile map so playuer knows where to put colors
func build_hint_tile_map():
	for cell in $VictoryTileMap.get_used_cells():
		#MY EYES, THEY BLEED
		$HintTileMap.set_cell(cell.x, cell.y, $HintTileMap.tile_set.find_tile_by_name($HintTileMap.tile_set.tile_get_name($VictoryTileMap.get_cell(cell[0], cell[1])) + "hint"))
	
func next_level(binds):
	global.next_level_player_health(get_tree().get_nodes_in_group("player")[0].health)
	
	var levelPoints = calculate_level_score()
	global.add_to_score(levelPoints)
	
	var nextLevel = get_level_data().nextLevel
	global.goto_scene("res://levels/"+nextLevel+".tscn")
	
func calculate_level_score():
	var score = 0
	score += $VictoryTileMap.get_used_cells().size() * tileGoodPointValue
	score += ($ActiveTileMap.get_used_cells().size() - $VictoryTileMap.get_used_cells().size()) * tileBadPointValue
	return score

func get_level_data():
	return get_owner().get_node("LevelData")

func _process(delta):
	if(!victoryDoorOpen && check_for_win_condition()):
		open_victory_door()
	if(Input.is_action_just_pressed("music_toggle")):
		if get_owner().get_node("Music").playing:
			get_owner().get_node("Music").stop()
			global.shouldPlayMusic = false
		else:
			get_owner().get_node("Music").play()
			global.shouldPlayMusic = true

# gets the tile coords based on game coords
func get_tile_coords_by_game_coords(x,y):
	return $ActiveTileMap.world_to_map(Vector2(x,y))

func convert_tile_coords_to_game_coords(x,y):
	return $ActiveTileMap.map_to_world(Vector2(x,y))

#converts the tile at this position to the specified color
func convert_tile_to_color(x,y,color):
	convert_tile_to_index(x, y, $ActiveTileMap.tile_set.find_tile_by_name(color+"tile"))

func convert_tile_to_index(x,y,index):
	var tile = get_tile_coords_by_game_coords(x,y)
	
	check_for_matching_tile_play_sound(tile.x, tile.y, index)
	
	$ActiveTileMap.set_cell(tile.x, tile.y, index)
	
#if a matching tile is filled then sound for it
func check_for_matching_tile_play_sound(x,y,index):
	var victoryTile = $VictoryTileMap.get_cell(x,y)
	var currentActiveTile = $ActiveTileMap.get_cell(x,y)
	if victoryTile > 0 && currentActiveTile != victoryTile:
		if victoryTile == index:
			get_owner().get_node("AnimationPlayer").play("matchingTileSound")
	
	
func get_cell_width():
	return $ActiveTileMap.cell_size.x;
	
func get_cell_height():
	return $ActiveTileMap.cell_size.y;

func clear_tile(x,y):
	convert_tile_to_index(x, y, -1)

#Check if our player's tile map matches victory conditions
func check_for_win_condition():
	for cell in $VictoryTileMap.get_used_cells():
		if $ActiveTileMap.get_cell(cell[0], cell[1])  != $VictoryTileMap.get_cell(cell[0], cell[1]):
			return false
			
	return true;

func get_cell_tile_index_by_game_coords(x,y):
	var mapCoords = get_tile_coords_by_game_coords(x,y)
	return get_cell_tile_index(mapCoords.x, mapCoords.y)

# this is expecting tilemap coords not game coords
func get_cell_tile_index(tileMapX,tileMapY):
	return $ActiveTileMap.get_cellv(Vector2(tileMapX,tileMapY))

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
	print("open victory")
	get_owner().get_node("AnimationPlayer").play("openVictoryDoors")
	get_owner().get_node("Walls/DoorWall/CollisionShape2D").disabled = true
	$Area2D.connect("body_entered", self, "next_level", [], CONNECT_ONESHOT)
	
func spawn_instance_on_random_point(instance):
	var spawns = get_tree().get_nodes_in_group("spawn")
	if(spawns.size() > 0):
		var spawn = spawns[rand_range(0, spawns.size()-1)]
		instance.position = spawn.position
		get_tree().get_root().add_child(instance)
