extends "BasicEnemy.gd"

func _ready():
	bloodColor = "red"
	maxMoveSpeed = 150 #gimp :D
	set_process(true)
	set_physics_process(true)

func _process(delta):
	if(check_if_player_close_for_attack()):
		attack()
	
func _physics_process(delta):
	move_character_towards_player()
	pass
