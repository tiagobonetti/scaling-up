extends Node2D


const INTERNAL_RESOLUTION: Vector2 = Vector2(320.0, 180.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	_dothing.call_deferred()

func _dothing():
	var root = get_tree().root
	
	var pixel_viewport = SubViewport.new()
	pixel_viewport.size = INTERNAL_RESOLUTION
	pixel_viewport.size_2d_override = INTERNAL_RESOLUTION
	pixel_viewport.size_2d_override_stretch = true
	pixel_viewport.snap_2d_transforms_to_pixel = true
	pixel_viewport.snap_2d_vertices_to_pixel = true
	
	pixel_viewport.physics_object_picking = true  # Need to forward physics picking!
	pixel_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	pixel_viewport.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_DISABLED
	
	var container = SubViewportContainer.new()
	container.anchor_bottom = 1.0
	container.anchor_right = 1.0
	container.stretch = true
	container.size_flags_horizontal = Control.SIZE_FILL
	container.size_flags_vertical = Control.SIZE_FILL
	
	var aspect = AspectRatioContainer.new()
	aspect.anchor_bottom = 1.0
	aspect.anchor_right = 1.0
	aspect.ratio = INTERNAL_RESOLUTION.x / INTERNAL_RESOLUTION.y
	aspect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	aspect.size_flags_vertical = Control.SIZE_EXPAND_FILL

	root.add_child(aspect)
	aspect.add_child(container)
	container.add_child(pixel_viewport)
	var current_scene = get_tree().current_scene
	current_scene.reparent(pixel_viewport, false)
	
	var text = Label.new()
	text.text = "High resolution text!"
	root.add_child(text)
