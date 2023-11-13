

# Constraints
# => Flight should be parabolic.
# => Start and endpoint are given.
# => Catapult uses v0 to determine distance.
# 
# # Parabolic flight:
# r = r0 + v0 * t * cos(theta)
# z = z0 + v0 * t * sin(theta) - 0.5 * g * t^2
# 
# Hence total time of flight:
# t = 2 * v0 * sin(theta) / g
# 
# Fill in total time:
# r1 = r0 + 2 * v0 * v0 * sin(theta) * cos(theta) / g
# (r1 - r0) * g = v0 * v0 * sin(2 * theta)
# v0 = sqrt((r1 - r0) * g / sin(2 * theta))

class LaunchArc:
	# Maybe gravity should be some global state?
	func _init(start_position, v0, ground_angle, theta=deg_to_rad(72), gravity=9.81):
		self.v0 = max(v0, 0.01)  # Prevent div by zero
		self.total_time = 2.0 * v0 * sin(theta) / gravity
		self.start_position = start_position
		self.direction = Vector2(cos(ground_angle), sin(ground_angle))
		self.theta = theta
		self.gravity = gravity
	
	func target_position(from_position, to_position, theta=deg_to_rad(72), gravity=9.81):
		var v0 = sqrt((to_position - from_position) * gravity / sin(2 * theta))
		var ground_angle = atan2(to_position[1] - from_position[1], to_position[0] - from_position[0])
		
		# Barf. This is how you make an instance of this class apparently.
		return get_script().new(from_position, v0, ground_angle, theta, gravity)
		
		#var v0 = 0.2 * (current_position - start_position).length()  # Velocity is determined by drag length

	func position_at(time):
		return [
			self.start_position - self.v0 * time * cos(self.theta) * self.direction,
			self.v0 * time * sin(self.theta) - 0.5 * self.gravity * time * time,
		]

	func step_arc(num_segments):
		var dt = self.total_time / (num_segments - 1)
		for step in range(num_segments):
			return self.position_at(dt * step)
			# oh no, godot has no yield :(
