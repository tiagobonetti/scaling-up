extends Area2D


var Transform = preload("res://Scripts/transform.gd")
var m_arc
var m_time


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	m_time += delta
	if m_arc and (m_time < m_arc.total_time):
		var xyz = m_arc.position_at(m_time)
		position = Transform.faux_3d(xyz)
		scale = Vector2(1.0 / (1.0 - 0.005 * xyz[1]), 1.0 / (1.0 - 0.005 * xyz[1]))
		get_node("Shadow").scale = Vector2(0.7 / (10.0 + xyz[1]), 0.07 / (3.0 + xyz[1]))
		get_node("Shadow").position = Vector2(-1.4, 6.125 + Transform.PERSPECTIVE_FACTOR * xyz[1])


func follow_arc(arc):
	m_arc = arc
	m_time = 0
	position = Transform.faux_3d(m_arc.position_at(0))
	get_node("Shadow").position = Vector2(-1.25, 6.125 + m_arc.position_at(0)[1])
