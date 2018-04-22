extends Node2D

var scorePointer = 0

func _enter_tree():
	global.clear_leftover_enemies()

func _ready():
	
	#REMOVE THIS!
	global.playerScore = 500
	
	$PlayAgainButton.connect("button_down", self, "start_over", [], CONNECT_ONESHOT)
	$ScoreAddTimer.connect("timeout", self, "add_to_score_label")
	
func start_over():
	global.playerHealth = global.maxPlayerHealth
	global.goto_scene("res://levels/level1.tscn")

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
