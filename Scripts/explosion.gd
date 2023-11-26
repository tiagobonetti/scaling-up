extends StaticBody2D
class_name Explosion

@export var base_damage := 40
@export var critical_probability := 0.15
@export var critical_damage := 40 

var damage := base_damage

func _ready():
	if Utils.roll_succeded(critical_probability):
		damage += critical_damage

	%AnimatedSprite2D.play("explode")
	%AnimatedSprite2D.connect("animation_finished", Callable(on_finished))

func on_finished():
	queue_free()
