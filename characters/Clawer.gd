extends "BasicEnemy.gd"


func _ready():
	attackTriggerDistance = 64
	damage = 15
	bloodColor = "red"
	maxMoveSpeed = 150 
	health = 200
	set_process(true)
	set_physics_process(true)

func _process(delta):
	pass
	
func _physics_process(delta):
	if(!isAttacking):
		move_character_towards_player()
		if(check_if_player_close_for_attack()):
			attack()