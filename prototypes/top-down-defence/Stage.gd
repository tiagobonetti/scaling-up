extends TileMap
class_name Stage

var enemy_scene = load("res://prototypes/top-down-defence/enemy.tscn")

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	print("Enemy instantiated", enemy)
	enemy.position = Vector2(randf_range(200, 960), randf_range(40, 600))	
