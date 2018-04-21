extends "BaseCharacter.gd"



func _ready():
	moveSpeed = 50
	maxMoveSpeed = 300
	damage = 50
	set_process(true)
	set_physics_process(true)

func _process(delta):
	
	#handle sprite flip by velocity
	if(velocity.x > 0):
		if($Sprite.flip_h):
			$Sprite.flip_h = false
	elif(velocity.x < 0):
		if(!$Sprite.flip_h):
			$Sprite.flip_h = true
	
func _physics_process(delta):
	
	#read inputs homie
	if(Input.is_action_pressed("ui_left")):
		velocity.x -= moveSpeed
	elif(Input.is_action_pressed("ui_right")):
		velocity.x += moveSpeed
	else:
		velocity.x -= velocity.x/10
		
	if(Input.is_action_pressed("ui_up")):
		velocity.y -= moveSpeed
	elif(Input.is_action_pressed("ui_down")):
		velocity.y += moveSpeed
	else:
		velocity.y -= velocity.y/10
		
	if(Input.is_action_pressed("ui_accept")):
		var foundHitBoxes = $AttackBox.get_overlapping_areas()
		for hitBox in foundHitBoxes:
			if(hitBox.get_owner().is_in_group("enemy")):
				hitBox.get_owner().take_damage(damage)

		
	#set a max speed for all directions
	if(velocity.length() > maxMoveSpeed):
		velocity = velocity.normalized()
		velocity.x *= maxMoveSpeed
		velocity.y *= maxMoveSpeed
		
	move_and_slide(velocity)
	