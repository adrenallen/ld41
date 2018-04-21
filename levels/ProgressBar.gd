extends ProgressBar

var playerNode

func _ready():
	
	playerNode = get_tree().get_nodes_in_group("player")[0]
	
	max_value = global.maxPlayerHealth
	min_value = 0
	value = playerNode.health
	
	set_process(true)
	
func _process(delta):
	value = playerNode.health
	pass