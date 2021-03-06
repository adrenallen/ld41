extends "BasicEnemy.gd"

var targetCell
var colorsSucked = []

func _ready():
	bloodColor = "blue"
	maxMoveSpeed = 500 
	set_process(true)
	set_physics_process(true)

func _process(delta):
	# find colors to eat!	
	if(!isSucking):
		var mapCoords = get_position_on_map()
		var tileMapObj = global.get_tile_map_container(self)
		var tileCoords = tileMapObj.get_tile_coords_by_game_coords(mapCoords.x, mapCoords.y)
		targetCell = tileMapObj.find_closest_used_tile(tileCoords.x, tileCoords.y)
	
func _physics_process(delta):
	if(!isSucking && targetCell != null):
		var target = global.get_tile_map_container(self).convert_tile_coords_to_game_coords(targetCell.x, targetCell.y)
		
		var mapCoords = get_position_on_map()
		var currentTileCoords = global.get_tile_map_container(self).get_tile_coords_by_game_coords(mapCoords.x, mapCoords.y)
		if(targetCell.x != currentTileCoords.x || targetCell.y != currentTileCoords.y):
			move_character_on_vector(target - get_position_on_map() + Vector2(0, 15))
		else:
			isSucking = true
			global.play_animation_if_not_playing("suck", $AnimationPlayer)
			$AnimationPlayer.connect("animation_finished",  self, "finish_sucking")
			velocity = Vector2(0,0)

#lol
func finish_sucking(binds=null):
	isSucking = false
	var mapPos = get_position_on_map()
	var tileMapObj = global.get_tile_map_container(self)
	
	#this is stupid syntax for an array
	colorsSucked.push_front (tileMapObj.get_cell_tile_index_by_game_coords(mapPos.x, mapPos.y))
	
	tileMapObj.clear_tile(mapPos.x, mapPos.y)
	
#override to explode before dying
func death():
	explode_sucked_colors()
	.death() #base call

func explode_sucked_colors():
	var mapObj = global.get_tile_map_container(self)
	var explodeDirections = []
	explodeDirections.push_front(Vector2(mapObj.get_cell_width(),0))
	explodeDirections.push_front(Vector2(mapObj.get_cell_width(),mapObj.get_cell_height()))
	explodeDirections.push_front(Vector2(0, mapObj.get_cell_height()))
	explodeDirections.push_front(Vector2(-1*mapObj.get_cell_width(),0))
	explodeDirections.push_front(Vector2(-1*mapObj.get_cell_width(),-1*mapObj.get_cell_height()))
	explodeDirections.push_front(Vector2(0, -1*mapObj.get_cell_height()))
	explodeDirections.push_front(Vector2(-1*mapObj.get_cell_width(),mapObj.get_cell_height()))
	explodeDirections.push_front(Vector2(mapObj.get_cell_width(),-1*mapObj.get_cell_height()))
	var mapPos = get_position_on_map()
	for color in colorsSucked:
		mapPos += explodeDirections[rand_range(0,explodeDirections.size())]
		mapObj.convert_tile_to_index(mapPos.x, mapPos.y, color)
		
