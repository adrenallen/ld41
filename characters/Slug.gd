extends "BasicEnemy.gd"

var bloodColors = ["red", "green", "blue"]

var bloodColorCodes = {
	"red": "#FF3333",
	"green": "#33FF33",
	"blue": "#3333FF"
	}
	
var slimeTileIndex

var goalDistanceToTarget = 64

var chasePlayerDistance = 192

var targetPosition = Vector2(0,0)

func _ready():
	minRunAnimSpeed = 2
	isAttacking = false
	randomize()
	var randNum = floor(rand_range(0, bloodColors.size()))
	
	attackTriggerDistance = 64
	
	bloodColor = bloodColors[randNum]
	
	modulate = Color(bloodColorCodes[bloodColor])
	
	slimeTileIndex = global.get_tile_map_container(self).get_tile_index_by_color_name(bloodColor)
	
	damage = 15
	
	maxMoveSpeed = 40
	health = 200
	 
	set_process(true)
	set_physics_process(true)
	
	find_a_spawn_location()
	
func _process(delta):
	pass
	
func _physics_process(delta):
	if(!isDead):
		if((find_player_position() - position).length() <= chasePlayerDistance):
			move_character_towards_player()
			if(!isAttacking && check_if_player_close_for_attack()):
				attack()
		else:
			move_character_on_vector((targetPosition-position).normalized())
			print(velocity.length())
			if((targetPosition-position).length() <= goalDistanceToTarget):
				find_a_spawn_location()
		leave_trail()
	
	
func leave_trail():
	var mapObj = global.get_tile_map_container(self)
	var slugPos = get_position_on_map()
	if(mapObj.get_cell_tile_index_by_game_coords(slugPos.x, slugPos.y) != slimeTileIndex):
		mapObj.convert_tile_to_index(slugPos.x, slugPos.y, slimeTileIndex)
	

func find_a_spawn_location():
	var spawns = get_tree().get_nodes_in_group("spawn")
	if(spawns.size() > 0):
		var randNum = floor(rand_range(0, spawns.size()))
		var possibleTarget = spawns[randNum]
		var possibleTargetDistance = (possibleTarget.position - position).length()
		if(possibleTargetDistance <= goalDistanceToTarget):
			find_a_spawn_location()
		else:
			targetPosition = possibleTarget.position
	else:
		targetPosition = null
		