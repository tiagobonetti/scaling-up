extends NavigationRegion2D
class_name StageArea

func _ready():
	print("_ready ", self)
	var nav_polygon: NavigationPolygon = get_navigation_polygon()
	add_children_outlines(nav_polygon, self)
	nav_polygon.make_polygons_from_outlines()
	set_navigation_polygon(nav_polygon)
	print("Navmesh:  ", nav_polygon.outlines)

func add_children_outlines(nav_polygon: NavigationPolygon, node: Node2D):
	for child in node.get_children():
		if child.get_child_count() > 0:
			add_children_outlines(nav_polygon, child)

		if child is CollisionPolygon2D:
			var child_transform: Transform2D = child.get_global_transform()
			var child_polygon: PackedVector2Array = child.polygon
			var child_outline: PackedVector2Array = child_transform * child_polygon
			nav_polygon.add_outline(child_outline)
