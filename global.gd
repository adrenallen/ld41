extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func goto_scene(scene):
	get_tree().change_scene(scene)
