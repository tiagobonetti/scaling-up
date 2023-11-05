extends RigidBody2D
class_name Enemy

var health: int = 20

func _ready():
	print("Enemy._ready= ", self)
	add_to_group("enemies")
	
func apply_damage(value):
	health -= value
	print("Apply damage value=%d health=%d" % [value, health])
	if health <= 0:
		queue_free()
