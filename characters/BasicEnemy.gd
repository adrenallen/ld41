extends "BaseCharacter.gd"

var velocity = Vector2(0,0)

var moveSpeed = 50
var maxSpeed = 300

func _ready():
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
	
func move_character():
		
	#set a max speed for all directions
	if(velocity.length() > maxSpeed):
		velocity = velocity.normalized()
		velocity.x *= maxSpeed
		velocity.y *= maxSpeed
		
	move_and_slide(velocity)
	
func find_player_position():
	var player = get_tree().get_nodes_in_group("player")[0]
	return player.position

func get_vector_to_player():
	return find_player_position() - position
	