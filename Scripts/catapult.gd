extends Area2D

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if redraw:
		queue_redraw()


func _draw():
	if is_dragging:
		draw_line(start_position, current_position, reticle_color)
		redraw = false


func _begin_drag(viewport, event, _shape_idx):
	if event.is_action_pressed("ui_press"):
		viewport.set_input_as_handled()
		start_position = _to_screen_coordinates(event.position)
		current_position = _to_screen_coordinates(event.position)
		is_dragging = true
		redraw = debug_drawing


func _input(event):
	if not is_dragging:
		return
	
	if event.is_action_released("ui_press"):
		is_dragging = false
		redraw = debug_drawing
	
	if is_dragging and event is InputEventMouseMotion:
		current_position = _to_screen_coordinates(event.position)
		redraw = debug_drawing
