extends "BaseCharacter.gd"

func _ready():
	set_process(true)
	set_physics_process(true)

func bleed_color():
	get_tree().get_root().get_node("Level/TileMapContainer").convert_tile_to_color(position.x, position.y, bloodColor)
	
func death():
	bleed_color()
	queue_free()

func _process(delta):
	
	#handle sprite flip by velocity
	if(velocity.x > 0):
		if($Sprite.flip_h):
			$Sprite.flip_h = false
	elif(velocity.x < 0):
		if(!$Sprite.flip_h):
			$Sprite.flip_h = true
	
func move_character():

	move_and_slide(velocity)

func move_character_towards_player():
	if(velocity.length() < maxMoveSpeed):
		var toPlayerVector = get_vector_to_player().normalized()
		toPlayerVector.x *= moveSpeed
		toPlayerVector.y *= moveSpeed
		#Add to existing velocity
		velocity += toPlayerVector
	else:
		velocity /= 10
		
	move_character()

func find_player_position():
	var player = get_tree().get_nodes_in_group("player")[0]
	return player.position

func get_vector_to_player():
	return find_player_position() - position