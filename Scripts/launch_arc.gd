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

var v0: float
var total_time: float
var start_position: Vector2
var direction: Vector2
var theta: float
var gravity: float


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
	
func position_at(time):
	return [
		self.start_position - self.v0 * time * cos(self.theta) * self.direction,
		self.v0 * time * sin(self.theta) - 0.5 * self.gravity * time * time,
	]

func final_position():
	return position_at(self.total_time)

func trajectory(num_steps):
	return Iterator.new(self, num_steps)


class Iterator:
	var _parent
	var _step: int = 0
	var _num_segments:int = 0
	var _dt: float
	
	func _init(parent, num_steps):
		self._parent = parent
		self._num_segments = num_steps
		self._dt = self._parent.total_time / (self._num_segments - 1)
	
	func _iter_init(_arg):
		self._step = 0
		return self._step < self._num_segments

	func _iter_next(_arg):
		self._step += 1
		return self._step < self._num_segments

	func _iter_get(_arg):
		return self._parent.position_at(self._dt * self._step)
