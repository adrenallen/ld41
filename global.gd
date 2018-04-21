extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var playerHealth
var maxPlayerHealth = 100

func _ready():
	if playerHealth == null :
		playerHealth = maxPlayerHealth
	pass

func goto_scene(scene):
	get_tree().change_scene(scene)

func play_animation_if_not_playing(animationName, animationPlayer):
	if(animationPlayer.current_animation != animationName):
		animationPlayer.play(animationName)
		
# clears all enemies from screen
# this was built to handle the spawners leaving enemies leftover on ocassion	
func clear_leftover_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
		
func get_tile_map_container(useNode):
	return useNode.get_tree().get_root().get_node("Level/TileMapContainer")