class_name Utils

const PERSPECTIVE_FACTOR = 0.8

static func faux_3d(position_3d: Vector3):
	var xy = Vector2(position_3d.x, position_3d.y)
	var z = position_3d.z
	return xy - Vector2(0, PERSPECTIVE_FACTOR * position_3d.z)

static func rand_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, 2 * PI))

# Using 0 to 360 creates errors, so the easier fix is to use a number very close to, but not identical to it
static func circle_points(center: Vector2 = Vector2.ZERO, radius: float = 1.0, angle_from: float = 0.0, angle_to: float = 359.999, num_of_points: int = 32):
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)

	for i in range(num_of_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / num_of_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	return points_arc
