extends TileMap
class_name Stage

@export var enemies_total: int = 10
@export var enemies_wait_time: float = 1.0

@onready var timer: Timer = get_node("Timer")
 
var enemy_scene = load("res://prototypes/top-down-defence/enemy.tscn")
var enemies_count: int = 0

func _ready():
	timer.wait_time = enemies_wait_time
	timer.connect("timeout", Callable(_on_timer_timeout))
	timer.start()


func spawn_enemy():
	var enemy: Enemy = enemy_scene.instantiate()
	add_child(enemy)
	print("Enemy spawned")
	enemy.position = Vector2(randf_range(700, 960), randf_range(40, 600))
	enemy.attack_closest()

func try_finish():
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		print("Stage completed!")
		timer.stop()

func _on_timer_timeout():
	if enemies_count < enemies_total:
		enemies_count += 1
		spawn_enemy()
	else:
		try_finish()
