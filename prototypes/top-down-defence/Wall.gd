extends Polygon2D
class_name WallP

@onready var body := StaticBody2D.new()
@onready var collision := CollisionPolygon2D.new()

func _ready() -> void:
	print("_ready ", self)
	add_child(body)
	body.add_child(collision)
	collision.polygon = polygon
