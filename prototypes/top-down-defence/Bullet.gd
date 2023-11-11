extends RigidBody2D
class_name Bullet

@export var speed: float = 800.0
@export var damage: int = 10

var tower: Tower = null

func shot(from: Tower, to: Enemy):
	tower = from
	look_at(to.global_position)
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed

func _on_body_entered(body):
	if body.has_method("apply_damage"):
		body.apply_damage(damage, tower)
	
	queue_free()

func _on_timer_timeout():
	queue_free()
