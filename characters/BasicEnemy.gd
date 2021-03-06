extends "BaseCharacter.gd"

var attackTriggerDistance = 48

var isSucking = false

var difficulty = 1

func _ready():
	set_process(true)
	set_physics_process(true)
	
func death():
	bleed_color()
	# this is dumb but stops other anims I think
	isAttacking = true
	isSucking = true
	global.play_animation_if_not_playing("death", $AnimationPlayer)
	$CollisionBox.disabled = true
	

func destroy_enemy():
	queue_free()
	
func _process(delta):
	
	#handle sprite flip by velocity
	flip_based_on_velocity()
	
	if(!isAttacking && !isSucking):
		if(velocity.length() > minRunAnimSpeed):
			global.play_animation_if_not_playing("run", $AnimationPlayer)
		elif(velocity.length() <= minRunAnimSpeed):
			global.play_animation_if_not_playing("idle", $AnimationPlayer)
	
func move_character():

	move_and_slide(velocity)

func move_character_towards_player():
	move_character_on_vector(get_vector_to_player().normalized())
	
func move_character_on_vector(vectorToMove):
	vectorToMove = vectorToMove.normalized()
	if(velocity.length() < maxMoveSpeed):
		vectorToMove.x *= moveSpeed
		vectorToMove.y *= moveSpeed
		#Add to existing velocity
		velocity += vectorToMove
	else:
		velocity /= 10
		
	move_character()

#Checks if player is in the attack box
func is_player_in_attack_box():
	var foundHitBoxes = $AttackBox.get_overlapping_areas()
	for hitBox in foundHitBoxes:
		if(hitBox.get_owner().is_in_group("player") && !hitBox.get_owner().isDead):
			return true
	return false

#Finds the player position
func find_player_position():
	var player = get_tree().get_nodes_in_group("player")
	if(player.size() > 0 && !player[0].isDead):
		return player[0].position
	else:
		return position

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
#			enemy.take_knockback(Vector2(knockback, knockback) * velocity.normalized())
	