@tool
extends Node2D
class_name CustomerSpawner

@export var spawn_cooldown: float = 3.0 # Seconds
@export var spawn_radius: float = 8 :
	set(value):
		spawn_radius = value
		queue_redraw()

@export var customer_scene: PackedScene = load("res://Scenes/Entities/Customer.tscn")

signal spawned(Node)

func _ready():
	if Engine.is_editor_hint():
		return

	%Timer.one_shot = true
	%Timer.connect("timeout", Callable(spawn))

func _draw():
	if Engine.is_editor_hint():
		draw_editor_hint()

func draw_editor_hint():
	var points_arc = Utils.circle_points(Vector2.ZERO, spawn_radius)
	var color = Color(Color.RED, 0.5)
	var colors = PackedColorArray([color])
	draw_polygon(points_arc, colors)	

func schedule_next_spawn():
	%Timer.start(spawn_cooldown + randf_range(-0.5, 0.5))

func stop():
	%Timer.stop()

func spawn():
	schedule_next_spawn() # must to here for consistency on spawn event
	spawn_customer()


func spawn_customer():
	var random_distance = randf_range(0, spawn_radius)
	var initial_position = global_position + Utils.rand_direction() * random_distance
	var customer := customer_scene.instantiate()
	add_child(customer)
	customer.global_position = initial_position
	spawned.emit(customer)
	print("Customer spawned at: ", initial_position)
	
