extends "BasicEnemy.gd"

func _ready():
	bloodColor = "red"
	maxMoveSpeed = 150 #gimp :D
	set_process(true)
	set_physics_process(true)

func _process(delta):
	pass
	
func _physics_process(delta):
	move_character_towards_player()
	pass
