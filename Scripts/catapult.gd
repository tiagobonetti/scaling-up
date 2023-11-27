extends Area2D
class_name Catapult

var Transform = preload("res://Scripts/transform.gd")
var LaunchArc = preload("res://Scripts/launch_arc.gd")
var Product = preload("res://Scenes/Entities/Product.tscn")
var reticle_color = Color(1.0, 0.0, 0.0)
var shadow_color = Color(0.0, 0.0, 0.0)
var start_position = Vector2()
var current_position = Vector2()
var is_dragging = false
var redraw = false
var debug_drawing = true


func from_screen_coordinates(x):
	return global_transform.affine_inverse() * x


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta):
	if redraw:
		queue_redraw()


func create_arc():
	return LaunchArc.new(
		start_position,
		(current_position - start_position).length(),  # Velocity is determined by drag length
		atan2(current_position[1] - start_position[1], current_position[0] - start_position[0])
	)


func _draw():
	if is_dragging:
		var arc = create_arc()
		var xyz = [start_position, 0]

		for coordinate in arc.trajectory(25):
			draw_line(
				Transform.faux_3d(xyz),
				Transform.faux_3d(coordinate),
				reticle_color,
			)
			xyz = [coordinate[0], coordinate[1]]
		
		var final_position = arc.final_position()
		draw_line(
			start_position,
			Transform.faux_3d(final_position),
			shadow_color
		)
		redraw = false


func _begin_drag(viewport, event, _shape_idx):
	if event.is_action_pressed("ui_press"):
		%AnimatedSprite2D.play("load")
		viewport.set_input_as_handled()
		start_position = from_screen_coordinates(event.position)
		current_position = from_screen_coordinates(event.position)
		is_dragging = true
		redraw = debug_drawing


func _input(event):
	if not is_dragging:
		return
	
	if event.is_action_released("ui_press"):
		is_dragging = false
		redraw = debug_drawing
		
		%AnimatedSprite2D.play("fire")
		
		var launched_product = Product.instantiate()
		add_child(launched_product)
		launched_product.position = start_position
		launched_product.follow_arc(create_arc())

	if is_dragging and event is InputEventMouseMotion:
		current_position = current_position + 10 * event.relative
		%AnimatedSprite2D.flip_h = global_position.x - event.position.x < 0
		redraw = debug_drawing
