extends "BaseCharacter.gd"

var isCleaning = false

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
	
	if(!isAttacking && !isCleaning):
		if(velocity.length() > 6):
			global.play_animation_if_not_playing("run", $AnimationPlayer)
		elif(velocity.length() <= 6):
			global.play_animation_if_not_playing("idle", $AnimationPlayer)
	
func _physics_process(delta):
	
	if(!isAttacking && !isCleaning):
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
			
		#set a max speed for all directions
		if(velocity.length() > maxMoveSpeed):
			velocity = velocity.normalized()
			velocity.x *= maxMoveSpeed
			velocity.y *= maxMoveSpeed
			
		move_and_slide(velocity)
	
	if(Input.is_action_pressed("ui_accept") && !isAttacking):
		attack()
		
	if(Input.is_action_pressed("player_clean") && !isCleaning && !isAttacking):
		start_clean_tile()
		
	
	
func do_attack_damage():
	var foundHitBoxes = $AttackBox.get_overlapping_areas()
	for hitBox in foundHitBoxes:
		if(hitBox.get_owner().is_in_group("enemy")):
			var enemy = hitBox.get_owner()
			enemy.take_damage(damage)
			enemy.take_knockback(Vector2(knockback, knockback) * velocity.normalized())

func start_clean_tile():
	velocity = Vector2(0,0)
	isCleaning = true
	global.play_animation_if_not_playing("clean", $AnimationPlayer)
	$AnimationPlayer.connect("animation_finished", self, "clean_tile", [], CONNECT_ONESHOT)
	
func clean_tile(binds=null):
	var mapPos = get_position_on_map()
	get_tree().get_root().get_node("Level/TileMapContainer").clear_tile(mapPos.x, mapPos.y)
	isCleaning = false

func death():
	global.goto_scene("res://endgame.tscn")