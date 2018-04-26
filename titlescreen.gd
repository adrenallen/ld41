extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	global.clear_leftover_enemies()
	$Container/NewGameButton.connect("pressed", self, "start_new_game")
	$Container/HowToPlayButton.connect("pressed", self, "toggle_how_to_play")
	$HowToPlayPanel/HowToPlayCloseButton.connect("pressed", self, "toggle_how_to_play")
	set_process(true)
	
func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		#TODO - make this not cause player to attack on load
		start_new_game()	

func start_new_game():
	global.goto_scene("res://levels/level1.tscn")
	
func toggle_how_to_play():
	$HowToPlayPanel.visible = !$HowToPlayPanel.visible
