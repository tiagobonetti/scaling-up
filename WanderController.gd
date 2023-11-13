extends Node2D

@export var wander_range = 32

@onready var start_position = global_position
@onready var target_position = global_position

func update_target_position():
	var target_vector = Vector2(randf_range(-32, 32), randf_range(-32,32))
	target_position = start_position + target_vector

func _on_timer_timeout():
	update_target_position()
