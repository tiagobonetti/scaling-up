extends Area2D


var Transform = preload("res://Scripts/transform.gd")
var Explosion = preload("res://Scenes/Entities/Explosion.tscn")
var m_arc
var m_time


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	m_time += delta
	if m_arc:
		if m_time < m_arc.total_time:
			var xyz = m_arc.position_at(m_time)
			position = Transform.faux_3d(xyz)
			var size_factor = 1.0 / (1.0 - 0.005 * xyz[1])
			scale = Vector2(size_factor, size_factor)
			get_node("Shadow").scale = Vector2(0.3 / (7.0 + 0.1 * xyz[1]), 0.03 / (2.0 + 0.1 * xyz[1]))
			get_node("Shadow").position = Vector2(0, 3 + Transform.PERSPECTIVE_FACTOR * xyz[1] / size_factor)
		else:
			var explosion = Explosion.instantiate()
			get_node("../").add_child(explosion)  # Bind to parent
			explosion.position = m_arc.final_position()[0]
			queue_free()


func follow_arc(arc):
	m_arc = arc
	m_time = 0
	position = Transform.faux_3d(m_arc.position_at(0))
	get_node("Shadow").position = Vector2(0, 3 + m_arc.position_at(0)[1])
