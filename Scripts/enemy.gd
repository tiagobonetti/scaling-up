extends CharacterBody2D
class_name Enemy

@export var health: int = 80
@export var movement_speed: float = 180

@export var acceleration := 100
@export var max_speed := 200
@export var friction := 2000

@export var target_position := Vector2(150, 100)
@export var target_distance := 10

signal died

var target_delta := Vector2.ZERO:
	get: return target_position - global_position

var damage_sources := []

func _physics_process(delta):
	if target_delta.length() >= target_distance:
		velocity = velocity.move_toward(target_delta.normalized() * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	detect_damage()
	animate()

func animate():
	if velocity.length() > 1:
		%AnimationPlayer.play("RunRight" if target_delta.x > 0 else "RunLeft")
	else:
		%AnimationPlayer.play("Idle")

func detect_damage():
	if get_slide_collision_count() == 0:
		return 

	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		
		if not collider.has_method("get_damage") or collider in damage_sources:
			return

		apply_damage(collider.get_damage())
		damage_sources.append(collider)

func apply_damage(value: int):
	health -= value
	print("Apply damage value=%d health=%d" % [value, health])
	if health <= 0:
		died.emit()
		queue_free()
