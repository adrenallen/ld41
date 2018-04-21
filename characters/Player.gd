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
		
	#set a max speed for all directions
	if(velocity.length() > maxSpeed):
		velocity = velocity.normalized()
		velocity.x *= maxSpeed
		velocity.y *= maxSpeed
		
	move_and_slide(velocity)
	