extends "BasicEnemy.gd"

func _ready():
	bloodColor = "green"
	maxMoveSpeed = 100 #gimp :D
	set_process(true)
	set_physics_process(true)

func _process(delta):
	pass
	
func _physics_process(delta):
	move_character_towards_player()
	pass
