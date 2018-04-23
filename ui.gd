extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var endScene = preload("res://endgame.tscn")

func _ready():
	# Called every time the node is added to the scene.
	
	#7 minutes before submission hack to make a sound
	if(global.get_tile_map_container(self).get_level_data().nextLevel != "level1" && global.get_tile_map_container(self).get_level_data().nextLevel != "level2"):
		$NewRoomSound.play()

func lose_game():
	var endSceneInstance = endScene.instance()
	global.get_tile_map_container(self).get_owner().get_node("Music").stop()
	$AnimationPlayer.stop()
	$LoseGameSound.play(0)
	endSceneInstance.z_index = 4050
	$ProgressBar.visible = false
	$ScoreBox.visible = false
	$EndGamePopup.add_child(endSceneInstance)
	$EndGamePopup.visible = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
