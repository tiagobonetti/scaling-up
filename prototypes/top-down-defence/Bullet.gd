extends RigidBody2D
class_name Bullet

var speed: float = 800.0
var damage: int = 10 

func _ready():
	print("Bullet._ready= ", self)
	
func target_enemy(enemy: Enemy):
	look_at(enemy.global_position)
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed

func _on_body_entered(body):
	print("Bullet._on_body_entered= ", body)
	if body.has_method("apply_damage"):
		body.apply_damage(damage)
		queue_free()
	

func _on_timer_timeout():
	queue_free()
