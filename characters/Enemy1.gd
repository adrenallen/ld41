extends "BasicEnemy.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	set_physics_process(true)
	

func _process(delta):
	print(get_vector_to_player())
	pass
	
func _physics_process(delta):
	
	move_character()
	pass
