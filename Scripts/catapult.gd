extends Area2D

var LaunchArc = preload("res://Scripts/launch_arc.gd")
var Product = preload("res://Scenes/Entities/Product.tscn")
var reticle_color = Color(1.0, 0.0, 0.0)
var shadow_color = Color(0.0, 0.0, 0.0)
var start_position = Vector2()
var current_position = Vector2()
var is_dragging = false
var redraw = false
var debug_drawing = true
var perspective_factor = 0.6


func _to_screen_coordinates(x):
	return global_transform.affine_inverse() * x

func faux_3d(xy, z):
	return xy - Vector2(0, perspective_factor * z)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta):
	if redraw:
		queue_redraw()


func _draw():
	if is_dragging:
		var arc = LaunchArc.new(	
			start_position,
			0.2 * (current_position - start_position).length(),  # Velocity is determined by drag length
			atan2(current_position[1] - start_position[1], current_position[0] - start_position[0])
		)
		
		var xy = start_position
		var z = 0

		for coordinate in arc.trajectory(25):
			draw_line(
				_to_screen_coordinates(faux_3d(xy, z)),
				_to_screen_coordinates(faux_3d(coordinate[0], coordinate[1])),
				reticle_color,
			)
			xy = coordinate[0]
			z = coordinate[1]
		
		var final_position = arc.final_position()
		draw_line(
			_to_screen_coordinates(start_position),
			_to_screen_coordinates(faux_3d(final_position[0], final_position[1])),
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
		
		var launched_product = Product.instantiate()
		add_child(launched_product)
		launched_product.position = _to_screen_coordinates(start_position)
		# launched_product.apply_impulse(- 5 * (current_position - start_position))

	if is_dragging and event is InputEventMouseMotion:
		current_position = event.position
		redraw = debug_drawing
