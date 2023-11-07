extends RigidBody2D
class_name Enemy

@export var health: int = 80
@export var movement_speed: float = 40.0

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

func _ready():
	add_to_group("enemies")
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	navigation_agent.max_speed = movement_speed

func attack_closest():
	navigation_agent.target_position = Utils.find_closest(self, "towers").global_position

func _physics_process(_delta: float):
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = (next_path_position - global_position).normalized() * movement_speed
	navigation_agent.set_velocity(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	linear_velocity = safe_velocity

func apply_damage(value):
	health -= value
	print("Apply damage value=%d health=%d" % [value, health])
	if health <= 0:
		queue_free()