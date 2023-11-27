extends CharacterBody2D
class_name Customer

@export var health: int = 80
@export var movement_speed: float = 180

@export var acceleration := 500
@export var max_speed := 100
@export var friction := 200
@export var collision_nudge := 500
@export var target_max_distance := 20

@export var happy_cooldown_s := 10.0
@export var search_cooldown_s := 10.0

signal died
signal bought

var product_recognition := 0.0
var damage_sources := []

func start_happy():
	%NavigationAgent2D.set_target_position(position + Utils.rand_direction() * 1024)
	schedule_next_search(happy_cooldown_s)

func start_search():
	print("start search")
	schedule_next_search(search_cooldown_s)
	for i in 100:
		var rand_x = randf_range(10, 310)
		var rand_y = randf_range(10, 182)
		%NavigationAgent2D.set_target_position(Vector2(rand_x, rand_y))
		if %NavigationAgent2D.is_target_reachable():
			break

func schedule_next_search(time_s: float):
	%SearchTimer.start(time_s + randf_range(-1, 1))

func _ready():
	%SearchTimer.one_shot = true
	%SearchTimer.timeout.connect(Callable(start_search))
	%NavigationAgent2D.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED
	start_search()

func _physics_process(delta):
	chase(delta)
	move_and_slide()
	handle_collision(delta)
	handle_animation()

func chase(delta):
	if %NavigationAgent2D.is_navigation_finished():
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		return
	
	var direction = (%NavigationAgent2D.get_next_path_position() - global_position).normalized()
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

func handle_animation():
	if velocity.length() > 1:
		var dx = %NavigationAgent2D.get_next_path_position().x - global_position.x
		%AnimationPlayer.play("RunRight" if dx > 0 else "RunLeft")
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
