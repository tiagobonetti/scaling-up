@tool
extends Node2D
class_name EnemySpawner

@export var spawn_total := 10
var enemy_spawned := 0

@export var spawn_cooldown: float = 1.0 # Seconds
@export var spawn_radius: float = 20 :
	set(value):
		spawn_radius = value
		queue_redraw()

@export var enemy_scene: PackedScene = load("res://Scenes/Entities/Enemy.tscn")

var enemy_group := "enemies"

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
	enemy_spawned += 1
	if enemy_spawned < spawn_total:
		%Timer.start(spawn_cooldown)

func spawn_enemy():
	var random_distance = randf_range(0, spawn_radius)
	var initial_position = global_position + Utils.rand_direction() * random_distance

	var enemy := enemy_scene.instantiate()
	add_child(enemy)
	enemy.add_to_group(enemy_group)
	enemy.global_position = initial_position
	print("Enemy spawned at: ", initial_position)
	
