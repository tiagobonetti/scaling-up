extends StaticBody2D
class_name Explosion

@export var damage := 20

func _ready():
	%AnimatedSprite2D.play("explode")
	%AnimatedSprite2D.connect("animation_finished", Callable(on_finished))

func on_finished():
	queue_free()
