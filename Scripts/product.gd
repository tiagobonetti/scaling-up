extends Area2D

var Explosion := preload("res://Scenes/Entities/Explosion.tscn")
var m_arc
var m_time

# Called when the node enters the scene tree for the first time.
func _ready():
	%AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	m_time += delta
	if not m_arc:
		return

	if m_time < m_arc.total_time:
		var position_3d = m_arc.position_3d_at(m_time)
		position = Utils.faux_3d(position_3d)
		var z = position_3d.z
		var size_factor = 1.0 / (1.0 - min(0.5, 0.005 * z))  # Cap scale to not get unreasonably big ball
		scale = Vector2(size_factor, size_factor)
		%Shadow.scale = Vector2(0.3 / (7.0 + 0.1 * z), 0.03 / (2.0 + 0.1 * z))
		%Shadow.position = Vector2(0, 3 + Utils.PERSPECTIVE_FACTOR * z / size_factor)
	else:
		var explosion = Explosion.instantiate()
		get_parent().add_child(explosion)
		explosion.position = m_arc.final_position()[0]
		queue_free()

func follow_arc(arc):
	m_arc = arc
	m_time = 0
	var position_3d = m_arc.position_3d_at(0)
	position = Utils.faux_3d(position_3d)
	%Shadow.position = Vector2(0, 3 + position_3d.z)

func buy():
	queue_free()
