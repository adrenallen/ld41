extends Node

var levelNode

onready var enemyList = {
	"clawer": preload("res://characters/Clawer.tscn"),
	"enemy1": preload("res://characters/Enemy1.tscn"),
	"sucker": preload("res://characters/Sucker.tscn")
}

var colorEnemyList = {
	"red": ["clawer"],
	"blue": ["sucker"],
	"green": ["enemy1"]
}


func _ready():
	set_process(true)


func _process(delta):
	if(levelNode != null):
		direct()
		
		
func direct():
	if(levelNode.spawnTimer.time_left <= 0):
		check_and_spawn_enemies()
	
func check_and_spawn_enemies():
	var enemies = levelNode.get_tree().get_nodes_in_group("enemy")
	var difficultyCount = 0
	var enemyColorCount = {
		"red": 0,
		"green": 0,
		"blue": 0
	}
	for enemy in enemies:
		enemyColorCount[enemy.bloodColor] += 1
		difficultyCount += enemy.difficulty
		
	var levelData = levelNode.get_level_data()
		
	if(enemies.size() > levelData.maxEnemies):
		return #do nothing we have max enemies
	
	if(enemyColorCount["green"] < levelData.greenEnemies):
		spawn_enemy("green")	
	if(enemyColorCount["red"] < levelData.redEnemies):
		spawn_enemy("red")
	if(enemyColorCount["blue"] < levelData.blueEnemies):
		spawn_enemy("blue")
	
		
func spawn_enemy(color=null):
	if(color == null):
		return
	levelNode.spawn_instance_on_random_point(enemyList[colorEnemyList[color][0]].instance())
	levelNode.spawnTimer.start()
		
	
func init_director(levelNode):
	self.levelNode = levelNode
	



