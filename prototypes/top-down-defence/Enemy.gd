extends RigidBody2D
class_name Enemy

@export var health: int = 80
@export var movement_speed: float = 180

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

static var avoidance_count: int = 0
static var avoidance_base: int = 8

func _ready():
	add_to_group("enemies")
	navigation_agent.velocity_computed.connect(Callable(set_linear_velocity))
	navigation_agent.max_speed = movement_speed
	
func attack_closest():
	print("attack closest")
	navigation_agent.target_position = Utils.find_closest(self, "towers").global_position

func apply_damage(value: int, _source: Tower):
	health -= value
	print("Apply damage value=%d health=%d" % [value, health])
	if health <= 0:
		queue_free()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var next_position := navigation_agent.get_next_path_position() 
	var next_direction := (next_position - global_position).normalized()
	navigation_agent.set_velocity(next_direction * movement_speed)
	look_at(next_position)




