extends Node2D
class_name Stage

var total_time_s := 0.0

var enemies_died := 0
var enemies_total := 0

var products_sold := 0
var products_sold_total := 10

var completed:
	get:
		return enemies_died >= enemies_total or products_sold >= products_sold_total

func _ready():
	%CenterLabel.visible = false
	for spawner_node in find_children("", "EnemySpawner"):
		var spawner = spawner_node as EnemySpawner
		assert(spawner)
		spawner.spawned.connect(Callable(on_spawned))
		enemies_total += spawner.enemies_total

func _process(delta):
	if completed:
		return

	total_time_s += delta
	update_top_label()

func update_top_label():
	var minutes = int(total_time_s / 60)
	var seconds = fmod(total_time_s, 60.0)
	%TopLabel.text = "Time: %d:%04.1f Sold: %02d Killed: %02d" % [minutes, seconds, products_sold ,enemies_died]
	if completed:
		%CenterLabel.visible = true

func on_spawned(enemy: Enemy):
	enemy.died.connect(Callable(on_died))
	enemy.bought.connect(Callable(on_bought))

func on_died():
	enemies_died += 1
	update_top_label()

func on_bought():
	products_sold += 1
	update_top_label()
