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
	
	if(!isAttacking):
		if(velocity.length() > 6):
			global.play_animation_if_not_playing("run", $AnimationPlayer)
		elif(velocity.length() <= 6):
			global.play_animation_if_not_playing("idle", $AnimationPlayer)
	
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
	
	if(Input.is_action_pressed("ui_accept") && !isAttacking):
		attack()
		
	#set a max speed for all directions
	if(velocity.length() > maxMoveSpeed):
		velocity = velocity.normalized()
		velocity.x *= maxMoveSpeed
		velocity.y *= maxMoveSpeed
		
	move_and_slide(velocity)
	
func attack():
	isAttacking = true
	global.play_animation_if_not_playing("attack", $AnimationPlayer)
	$AnimationPlayer.connect("animation_finished", self, "toggle_off_is_attacking", [], CONNECT_ONESHOT)
		
func do_attack_damage():
	print("Do damage")
	var foundHitBoxes = $AttackBox.get_overlapping_areas()
	for hitBox in foundHitBoxes:
		if(hitBox.get_owner().is_in_group("enemy")):
			var enemy = hitBox.get_owner()
			enemy.take_damage(damage)
			enemy.take_knockback(Vector2(knockback, knockback) * velocity.normalized())