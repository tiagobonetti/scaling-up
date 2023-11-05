extends Area2D

var product = preload("res://Scenes/Entities/Product.tscn")
var reticle_color = Color(1.0, 0.0, 0.0)
var shadow_color = Color(0.0, 0.0, 0.0)
var start_position = Vector2()
var current_position = Vector2()
var is_dragging = false
var redraw = false
var debug_drawing = true


func _to_screen_coordinates(x):
	return global_transform.affine_inverse() * x


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta):
	if redraw:
		queue_redraw()


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

func _draw():
	if is_dragging:		
		var perspective_factor = 0.8
		var v0 = 0.2 * (current_position - start_position).length()  # Velocity is determined by drag length
		v0 = max(v0, 0.01)  # Prevent div by zero
		var gravity = 9.81
		var theta = 2.0 * PI * 72 / 360
		var ground_angle = atan2(current_position[1] - start_position[1], current_position[0] - start_position[0])
		var total_time = 2.0 * v0 * sin(theta) / gravity
		
		var xc = start_position[0]
		var yc = start_position[1]
		var zc = 0
		var num_segments = 25.0
		var dt = total_time / (num_segments - 1)
		for step in range(num_segments):
			var t = dt * step
			var xc_last = xc
			var yc_last = yc
			var zc_last = zc
			xc = start_position[0] - v0 * t * cos(theta) * cos(ground_angle)
			yc = start_position[1] - v0 * t * cos(theta) * sin(ground_angle)
			zc = v0 * t * sin(theta) - 0.5 * gravity * t * t
			
			draw_line(
				_to_screen_coordinates(Vector2(xc_last, yc_last - perspective_factor * zc_last)),
				_to_screen_coordinates(Vector2(xc, yc - perspective_factor * zc)),
				reticle_color,
			)
		
		draw_line(
			_to_screen_coordinates(start_position),
			_to_screen_coordinates(
				Vector2(
					start_position[0] - v0 * total_time * cos(theta) * cos(ground_angle),
					start_position[1] - v0 * total_time * cos(theta) * sin(ground_angle)
					)
				),
			shadow_color
		)
		redraw = false


func _begin_drag(viewport, event, _shape_idx):
	if event.is_action_pressed("ui_press"):
		viewport.set_input_as_handled()
		start_position = event.position
		current_position = event.position
		is_dragging = true
		redraw = debug_drawing


func _input(event):
	if not is_dragging:
		return
	
	if event.is_action_released("ui_press"):
		is_dragging = false
		redraw = debug_drawing
		
		var launched_product = product.instantiate()
		add_child(launched_product)
		launched_product.position = _to_screen_coordinates(start_position)
		print(launched_product)
		launched_product.apply_impulse(- 5 * (current_position - start_position))
		
	
	if is_dragging and event is InputEventMouseMotion:
		current_position = event.position
		redraw = debug_drawing
