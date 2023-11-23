extends CharacterBody2D
class_name Enemy

@export var health: int = 80
@export var movement_speed: float = 180

@export var acceleration := 4
@export var max_speed := 2
@export var friction := 20

@export var target_position := Vector2.ZERO
@export var target_distance := 10

var target_delta := Vector2.ZERO:
	get: return target_position - global_position

func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	# remove to stop following mouse
	target_position = get_global_mouse_position()

	if target_delta.length() >= target_distance:
		velocity = velocity.move_toward(target_delta.normalized() * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_collide(velocity)
	animate()

func animate():
	if velocity.length() > 1:
		$AnimationPlayer.play("RunRight" if target_delta.x > 0 else "RunLeft")
	else:
		$AnimationPlayer.play("Idle")

func apply_damage(value: int):
	health -= value
	print("Apply damage value=%d health=%d" % [value, health])
	if health <= 0:
		queue_free()
