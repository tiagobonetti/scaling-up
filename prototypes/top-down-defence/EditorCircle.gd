extends Polygon2D
class_name EditorCircle

@export var editor_something := 2

func _ready():
	print("EditorView Engine.is_editor_view=", Engine.is_editor_hint())


func update():
	pass
	
func _draw():
	if not Engine.is_editor_hint():
		return

	var radius = 80
	var color = Color(1.0, 1.0, 1.0, 0.5)
	draw_circle(Vector2.ZERO, radius, color)
