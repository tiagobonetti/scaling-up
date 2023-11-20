extends Node


@onready var sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("explode")
	sprite.connect("animation_finished", die)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func die():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	queue_free()
