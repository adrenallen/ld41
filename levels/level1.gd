extends "BaseLevel.gd"


func _ready():
	nextLevel = "level2"
	set_process(true)
	get_owner().get_node("SpawnTimer").connect("timeout", self, "spawn_base_enemy")
	
	
func _process(delta):
	pass	
	
	
