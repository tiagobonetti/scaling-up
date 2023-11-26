extends StaticBody2D
class_name Product

var Explosion := preload("res://Scenes/Entities/Explosion.tscn")
var m_arc
var m_time

# Probability to sell on quality
# Always the same on every hit (provide some kind of floor of efficiency)
var quality := 0.25

# Probability of sell by recognition
# This also accumulates on target so sucessive hits will eventually sell an item (>= 100)
var recognition := 0.1

var sold := false

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
		# While the product is in fligth (z is too high) we don't collide
		var in_fligth = z / 2 > %CollisionShape2D.shape.radius
		if in_fligth != %CollisionShape2D.disabled:
			%CollisionShape2D.set_deferred("disabled", in_fligth)

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
