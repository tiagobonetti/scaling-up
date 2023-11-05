extends Area2D

var mouse_previous = Vector2()
var is_dragging = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _begin_drag(viewport, event, shape_idx):
	if event.is_action_pressed("ui_press"):
		viewport.set_input_as_handled()
		mouse_previous = event.position
		is_dragging = true


func _input(event):
	pass
