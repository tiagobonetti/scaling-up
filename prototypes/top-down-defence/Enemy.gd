extends RigidBody2D
class_name Enemy
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@export var health: int = 80
@export var movement_speed: float = 160.0

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

func _ready():
	add_to_group("enemies")
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	navigation_agent.max_speed = movement_speed
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	#set_movement_target(movement_target_position)


func attack_closest():
	set_movement_target(Utils.find_closest(self, "towers").global_position)
	#navigation_agent.target_position = Utils.find_closest(self, "towers").global_position

func _old_physics_process(_delta: float):
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

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var next_position := navigation_agent.get_next_path_position()
	var delta_position := next_position - global_position
	navigation_agent.set_velocity(delta_position.normalized() * movement_speed)
