extends Node


const PERSPECTIVE_FACTOR = 0.8


static func faux_3d(xyz):
	var xy = xyz[0]
	var z = xyz[1]
	return xy - Vector2(0, PERSPECTIVE_FACTOR * z)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
