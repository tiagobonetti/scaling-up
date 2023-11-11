extends Node2D
class_name Tower

@export var bullet_wait_time: float = 0.3

@onready var bullet_scene = load("res://prototypes/top-down-defence/bullet.tscn")
@onready var timer: Timer = get_node("Timer")

func _ready():
	add_to_group("towers")
	timer.wait_time = bullet_wait_time
	timer.connect("timeout", Callable(_on_timer_timeout))
	timer.start()

func find_closest_enemy() -> Enemy:
	return Utils.find_closest(self, "enemies")

func shoot(enemy: Enemy):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.shot(self, enemy)

func _on_timer_timeout():
	var enemy = find_closest_enemy()
	if enemy:
		shoot(enemy)
