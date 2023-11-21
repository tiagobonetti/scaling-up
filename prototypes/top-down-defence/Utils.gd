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


static func circle_points(center: Vector2 = Vector2.ZERO, radius: float = 1.0, angle_from: float = 0.0, angle_to: float = 359.999, num_of_points: int = 32):
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)

	for i in range(num_of_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / num_of_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	return points_arc
	
