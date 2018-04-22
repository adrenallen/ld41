extends "BasicEnemy.gd"


func _ready():
	attackTriggerDistance = 64
	bloodColor = "red"
	maxMoveSpeed = 150 #gimp :D
	set_process(true)
	set_physics_process(true)

func _process(delta):
	pass
	
func _physics_process(delta):
	if(!isAttacking):
		move_character_towards_player()
		if(check_if_player_close_for_attack()):
			attack()