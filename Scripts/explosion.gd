extends StaticBody2D
class_name Explosion

@export var damage := 20

func _ready():
	%AnimatedSprite2D.play("explode")
	%AnimatedSprite2D.connect("animation_finished", Callable(_on_finished))

func _on_finished():
	queue_free()

func get_damage():
	return damage
