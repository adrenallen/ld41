extends Node2D

var scorePointer = 0

func _enter_tree():
	pass


func _ready():
	$PlayAgainButton.connect("button_down", self, "start_over", [], CONNECT_ONESHOT)
	$BackToMenuButton.connect("button_down", self, "main_menu", [], CONNECT_ONESHOT)
	
	$ScoreAddTimer.connect("timeout", self, "add_to_score_label")
	
func start_over():
	global.clear_leftover_enemies()
	global.playerHealth = global.maxPlayerHealth
	global.playerScore = 0
	global.goto_scene("res://levels/level1.tscn")

func main_menu():
	global.clear_leftover_enemies()
	global.playerHealth = global.maxPlayerHealth
	global.playerScore = 0
	global.goto_scene("res://titlescreen.tscn")

func add_to_score_label():
	
	scorePointer += round(global.playerScore/20)
	
	if(scorePointer >= global.playerScore):
		$FinalScoreStretch/FinalScoreValue.text = str(global.playerScore)
		$ScoreAddTimer.disconnect("timeout", self, "add_to_score_label")
		return
		
	$FinalScoreStretch/FinalScoreValue.text = str(scorePointer)
	
	
	
	
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
