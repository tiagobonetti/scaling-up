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
		position = Transform.faux_3d(m_arc.position_at(m_time))


func follow_arc(arc):
	m_arc = arc
	m_time = 0
	position = Transform.faux_3d(m_arc.position_at(0))
