extends Node

var levelNode

onready var enemyList = {
	"clawer": preload("res://characters/Clawer.tscn"),
	"enemy1": preload("res://characters/Enemy1.tscn"),
	"sucker": preload("res://characters/Sucker.tscn"),
	"slug": preload("res://characters/Slug.tscn")
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
	
	var colorsToSpawn = []
	
	if(enemyColorCount["green"] < levelData.greenEnemies):
		colorsToSpawn.push_front("green")
	if(enemyColorCount["red"] < levelData.redEnemies):
		colorsToSpawn.push_front("red")
	if(enemyColorCount["blue"] < levelData.blueEnemies):
		colorsToSpawn.push_front("blue")
	
	var enemiesToSpawn = get_enemies_of_color(colorsToSpawn)
	
	var slugs = levelNode.get_tree().get_nodes_in_group("slug")
	if(levelData.slugs > slugs.size()):
		randomize()
		if(floor(rand_range(1, 100)) < levelData.difficulty):
			enemiesToSpawn.push_front(enemyList["slug"].instance())

	levelNode.create_spawner(enemiesToSpawn)	
	levelNode.spawnTimer.start()

func get_enemies_of_color(colors):
	var instances = []
	for color in colors:
		instances.push_front(enemyList[colorEnemyList[color][0]].instance())
	return instances
	
	
#func spawn_enemy(color=null):
#	if(color == null):
#		return
#	levelNode.spawn_instance_on_random_point(enemyList[colorEnemyList[color][0]].instance())
#	levelNode.spawnTimer.start()
		
	
func init_director(levelNode):
	self.levelNode = levelNode
	



