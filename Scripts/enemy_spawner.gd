@tool
extends Node2D
class_name EnemySpawner

@export var enemies_total := 10
var enemies_spawned := 0

@export var spawn_cooldown: float = 3.0 # Seconds
@export var spawn_radius: float = 20 :
	set(value):
		spawn_radius = value
		queue_redraw()

@export var enemy_scene: PackedScene = load("res://Scenes/Entities/Enemy.tscn")

signal spawned(Node)
signal finished

func _ready():
	if Engine.is_editor_hint():
		return

	%Timer.one_shot = true
	%Timer.connect("timeout", Callable(spawn_next))
	call_deferred("spawn_next")

func _draw():
	if Engine.is_editor_hint():
		draw_editor_hint()

func draw_editor_hint():
	var points_arc = Utils.circle_points(Vector2.ZERO, spawn_radius)
	var color = Color(Color.RED, 0.5)
	var colors = PackedColorArray([color])
	draw_polygon(points_arc, colors)	

func spawn_next():
	spawn_enemy()
	enemies_spawned += 1
	if enemies_spawned < enemies_total:
		%Timer.start(spawn_cooldown)
	else:
		finished.emit()

func spawn_enemy():
	var random_distance = randf_range(0, spawn_radius)
	var initial_position = global_position + Utils.rand_direction() * random_distance

	var enemy := enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = initial_position
	spawned.emit(enemy)
	print("Enemy spawned at: ", initial_position)
	
