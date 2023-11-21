@tool
extends Node2D
class_name EnemySpawner

@export var enemy_pool_sizes := [2] #, 4, 5, 8, 12] 
@export var spawn_cooldown: int = 10.0 # Seconds
@export var spawn_radius: float = 100 :
	set(value):
		spawn_radius = value
		queue_redraw()

@export var enemy_scene: PackedScene = load("res://prototypes/top-down-defence/enemy.tscn")

var current_pool_index: int = 0

var finished:
	get:
		return current_pool_index >= enemy_pool_sizes.size()

var current_pool:
	get:
		return 0 if finished else enemy_pool_sizes[current_pool_index]


func _ready():
	if Engine.is_editor_hint():
		return

	%Timer.wait_time = spawn_cooldown
	%Timer.connect("timeout", Callable(update))
	%Timer.start()
	call_deferred("update")

func _draw():
	if not Engine.is_editor_hint():
		return

	var points_arc = Utils.circle_points(Vector2.ZERO, spawn_radius)
	var color = Color(Color.RED, 0.5)
	var colors = PackedColorArray([color])
	draw_polygon(points_arc, colors)

func update():
	if finished:
		try_complete()
	else:
		spawn_enemies(current_pool)
		current_pool_index += 1

func spawn_enemies(pool_size: int):
	for _i in pool_size:
		var random_distance = randf_range(0, spawn_radius)
		spaw_enemy_at(Utils.rand_direction() * random_distance)
	
func spaw_enemy_at(pos: Vector2):
	var enemy: Enemy = enemy_scene.instantiate()
	add_child(enemy)
	print("Enemy spawned")
	enemy.position = pos
	enemy.attack_closest()

func try_complete():
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		print("Stage completed!")
		%Timer.stop()

