extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var playerHealth
var maxPlayerHealth = 100
var playerScore = 0
var shouldPlayMusic = true

func rand_int(from, to):
	return range(from,to)[randi()%range(from,to).size()]

func _ready():
	if playerHealth == null :
		playerHealth = maxPlayerHealth
	pass

func add_to_score(value):
	playerScore += value
	display_score()

func display_score():
	print("set score to ", str(playerScore))
	get_tree().get_root().get_node("Level/UI/ScoreBox/ScoreValue").text = str(playerScore)

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

func next_level_player_health(health):
	var healthLost = maxPlayerHealth - health
	playerHealth = health + (healthLost/2) #give back half lost health each level

func get_tile_map_container(useNode):
	return useNode.get_tree().get_root().get_node("Level/TileMapContainer")