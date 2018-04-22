extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var endScene = preload("res://endgame.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func lose_game():
	var endSceneInstance = endScene.instance()
	endSceneInstance.z_index = 4050
	$EndGamePopup.add_child(endSceneInstance)
	$EndGamePopup.visible = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
