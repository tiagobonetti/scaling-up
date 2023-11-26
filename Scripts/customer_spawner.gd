@tool
extends Node2D
class_name CustomerSpawner

@export var spawned_max := 10
var spawned_count := 0

@export var spawn_cooldown: float = 3.0 # Seconds
@export var spawn_radius: float = 20 :
	set(value):
		spawn_radius = value
		queue_redraw()

@export var customer_scene: PackedScene = load("res://Scenes/Entities/Customer.tscn")

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
	spawn_customer()
	spawned_count += 1
	if spawned_count < spawned_max:
		%Timer.start(spawn_cooldown)
	else:
		finished.emit()

func spawn_customer():
	var random_distance = randf_range(0, spawn_radius)
	var initial_position = global_position + Utils.rand_direction() * random_distance
	var customer := customer_scene.instantiate()
	add_child(customer)
	customer.global_position = initial_position
	spawned.emit(customer)
	print("Customer spawned at: ", initial_position)
	
