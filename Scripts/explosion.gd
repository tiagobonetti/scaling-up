extends StaticBody2D
class_name Explosion

@export var damage := 40
@export var critical_probability := 0.15
@export var critical_multiplier := 1.75 

func _ready():
	%AnimatedSprite2D.play("explode")
	%AnimatedSprite2D.connect("animation_finished", Callable(on_finished))

func on_finished():
	queue_free()
