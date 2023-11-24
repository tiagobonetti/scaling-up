extends Node2D
class_name Stage

var total_time_s := 0.0

var enemies_died := 0
var enemies_total := 0

func _ready():
	%CenterLabel.visible = false
	for spawner_node in find_children("", "EnemySpawner"):
		var spawner = spawner_node as EnemySpawner
		assert(spawner)
		spawner.spawned.connect(Callable(on_spawned))
		enemies_total += spawner.enemies_total

func _process(delta):
	if enemies_died >= enemies_total:
		return

	total_time_s += delta
	update_top_label()

func update_top_label():
	var minutes = int(total_time_s / 60)
	var seconds = fmod(total_time_s, 60.0)
	%TopLabel.text = "Time: %d:%04.1f  Killed: %02d" % [minutes, seconds, enemies_died]

func on_spawned(enemy: Enemy):
	print("on_spawned: ", enemy)
	enemy.died.connect(Callable(on_died))

func on_died():
	print("on_died")
	enemies_died += 1
	
	if enemies_died >= enemies_total:
		%CenterLabel.visible = true
