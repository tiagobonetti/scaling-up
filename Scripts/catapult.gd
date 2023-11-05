extends Area2D

var product = preload("res://Scenes/Entities/Product.tscn")
var reticle_color = Color(1.0, 0.0, 0.0)
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


func _draw():
	if is_dragging:
		draw_line(
			_to_screen_coordinates(start_position),
			_to_screen_coordinates(current_position),
			reticle_color
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
