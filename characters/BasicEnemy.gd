extends "BaseCharacter.gd"

var attackTriggerDistance = 48

func _ready():
	set_process(true)
	set_physics_process(true)

func bleed_color():
	var mapPos = get_position_on_map()
	get_tree().get_root().get_node("Level/TileMapContainer").convert_tile_to_color(mapPos.x, mapPos.y, bloodColor)
	
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

#Checks if player is in the attack box
func is_player_in_attack_box():
	var foundHitBoxes = $AttackBox.get_overlapping_areas()
	for hitBox in foundHitBoxes:
		if(hitBox.get_owner().is_in_group("player")):
			return true
	return false

#Finds the player position
func find_player_position():
	var player = get_tree().get_nodes_in_group("player")[0]
	return player.position

#get the vector diff to player
func get_vector_to_player():
	return find_player_position() - position
	
#checks if player is close enough (by attackTriggerDistance) and if they are in the attack box
func check_if_player_close_for_attack():

	if(get_vector_to_player().length() <= attackTriggerDistance):
		if(is_player_in_attack_box()):
			return true	#player is close enough AND inside attack box
			
	#nothing found so false
	return false
	
func do_attack_damage():
	var foundHitBoxes = $AttackBox.get_overlapping_areas()
	for hitBox in foundHitBoxes:
		if(hitBox.get_owner().is_in_group("player")):
			var enemy = hitBox.get_owner()
			enemy.take_damage(damage)
			enemy.take_knockback(Vector2(knockback, knockback) * velocity.normalized())
	