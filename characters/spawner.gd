extends Node2D

var instancesToSpawn = []

func _ready():
	pass

func init_spawner(instances):
	instancesToSpawn = instances
	
func initiate_spawn():
	$AnimationPlayer.play("up")
	
func find_a_spawn_location():
	var spawns = get_tree().get_nodes_in_group("spawn")
	if(spawns.size() > 0):
		var spawn = spawns[rand_range(0, spawns.size()-1)]
		position = spawn.position
		z_index = position.y + 100
		return true
	else:
		print("Didn't find a spawn, skipping spawn!")
		destroy_spawner()
		
		
func spawn_instances():
	var moveAmount = 0 #to avoid stacking
	for instance in instancesToSpawn:
		instance.position = position + Vector2(0, moveAmount)
		moveAmount += 10
		get_tree().get_root().add_child(instance)
	
	
func destroy_spawner():
	queue_free()
	
