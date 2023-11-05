extends Node2D

var bullet_scene = load("res://prototypes/top-down-defence/bullet.tscn")

func closest_enemy(acc, enemy):
	var enemy_distance = (global_position - enemy.global_position).length()
	return [enemy, enemy_distance] if enemy_distance < acc[1] else acc

func find_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest = enemies.reduce(closest_enemy, [null, INF])
	return closest[0]


func _on_timer_timeout():
	var enemy = find_closest_enemy()
	if not enemy:
		print("No enemy found!")
		return
	
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	print(bullet)
	bullet.target_enemy(enemy)


