extends CharacterBody2D
class_name Customer

@export var health: int = 80
@export var movement_speed: float = 180

@export var acceleration := 500
@export var max_speed := 100
@export var friction := 200
@export var collision_nudge := 500
@export var target_max_distance := 20

signal died
signal bought

var product_position :=  Vector2(200 , 100) + Utils.rand_direction() * 20
var product_recognition := 0.0

@export var happy_cooldown_s := 10.0
var happy_position := Vector2.ZERO
var happy:
	get:
		return !%HappyTimer.is_stopped()

var damage_sources := []

func start_happy():
	product_recognition = 0.0
	happy_position = position + Utils.rand_direction() * 1024
	%HappyTimer.start(happy_cooldown_s)

func _ready():
	%HappyTimer.one_shot = true

func _physics_process(delta):
	var target_position := happy_position if happy else product_position
	var target_delta = target_position - global_position
	chase(delta, target_delta, target_max_distance)
	move_and_slide()
	handle_collision(delta)
	handle_animation(target_delta)

func chase(delta, target_delta, max_distance):
	if target_delta.length() >= max_distance:
		velocity = velocity.move_toward(target_delta.normalized() * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func handle_animation(target_delta):
	if velocity.length() > 1:
		%AnimationPlayer.play("RunRight" if target_delta.x > 0 else "RunLeft")
	else:
		%AnimationPlayer.play("Idle")

func handle_collision(delta):
	if get_slide_collision_count() == 0:
		return 

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		var other := collider as Customer
		if other:
			velocity = velocity.move_toward(collision.get_normal() * max_speed, collision_nudge * delta) 
			
		
		handle_damage(collider)
		handle_quality(collider)
		handle_recognition(collider)

func handle_damage(collider: Object):
	var explosion := collider as Explosion
	if explosion == null or explosion in damage_sources:
		return

	damage_sources.append(collider)
	apply_damage(explosion.damage)

func apply_damage(value: int):
	health -= value
	print("Received damage value=%d health=%d name=%s" % [name, value, health])
	if health <= 0:
		died.emit()
		queue_free()

func handle_quality(collider: Object):
	var product := collider as Product
	if product == null or product.sold:
		return

	if Utils.roll_succeded(product.quality):
		print("Sold! Great product! name=%s", name)
		buy(product)

func handle_recognition(collider: Object):
	var product := collider as Product
	if product == null or product.sold:
		return
	
	product_recognition += product.recognition
	if Utils.roll_succeded(product_recognition):
		print("Sold! I know this product! name=%s", name)
		buy(product)

func buy(product: Product):
	product.sold = true
	product.queue_free()
	bought.emit()
	start_happy()
