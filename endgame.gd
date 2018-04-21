extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Button.connect("button_down", self, "start_over", [], CONNECT_ONESHOT)
	
	
func start_over():
	global.goto_scene("res://levels/level1.tscn")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
