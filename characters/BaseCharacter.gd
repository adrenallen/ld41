extends KinematicBody2D

var health = 100
var bloodColor = "red"
var moveSpeed = 50
var maxMoveSpeed = 300
var damage = 10
var knockback = 2000
var isAttacking = false

var minRunAnimSpeed =6

var isFlippedH = false

var isDead = false
var velocity = Vector2()

func _ready():
	set_process(true)

func _process(delta):
	z_index = 100 + position.y

func bleed_color():
	var mapPos = get_position_on_map()
	global.get_tile_map_container(self).convert_tile_to_color(mapPos.x, mapPos.y, bloodColor)

func take_damage(damage):
	if(health > 0):
		health -= damage
		if(health <= 0):
			isDead = true
			death()
			
func take_knockback(knockback):
	move_and_slide(knockback * maxMoveSpeed)
	velocity = knockback * maxMoveSpeed
	
func get_position_on_map():
	return position  + $CollisionBox.get_transform().get_origin() 
	
func death():
	print("Please implement death in children!")

func attack():
	velocity = Vector2(0,0)
	toggle_on_is_attacking()
	global.play_animation_if_not_playing("attack", $AnimationPlayer)
	$AnimationPlayer.connect("animation_finished", self, "toggle_off_is_attacking", [], CONNECT_ONESHOT)

func toggle_on_is_attacking(binds=null):
	isAttacking = true
	
func toggle_off_is_attacking(binds=null):
	isAttacking = false
	
func flip_based_on_velocity():
	#handle sprite flip by velocity
	if(velocity.x > 0):
		if(isFlippedH):
			isFlippedH = false
			apply_scale(Vector2(-1, 1))
	elif(velocity.x < 0):
		if(!isFlippedH):
			isFlippedH = true
			apply_scale(Vector2(-1, 1))
	
	
