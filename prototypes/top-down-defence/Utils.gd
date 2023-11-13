class_name Utils

static func reduce_closest(acc, node: Node2D):
	
	var distance = (acc[0].global_position - node.global_position).length()
	if distance < acc[2]:
		acc[1] = node
		acc[2] = distance
	return acc


static func find_closest(origin: Node2D, group: String):
	var enemies =  origin.get_tree().get_nodes_in_group(group)
	var acc = enemies.reduce(Utils.reduce_closest, [origin, null, INF])
	return acc[1]

static func rand_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, 2 * PI))
