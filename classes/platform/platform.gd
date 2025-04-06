class_name Platform extends Polygon2D

@export var shadow_color : Color = Color(0.1, 0.1, 0.3, 0.5)

func _ready() -> void:
	var shadow_polygon : Polygon2D = Polygon2D.new()
	shadow_polygon.polygon = self.polygon
	shadow_polygon.color = shadow_color
	
	shadow_polygon.z_index = -1
	
	shadow_polygon.position = Vector2(2, 2)
	shadow_polygon.show_behind_parent = true
	
	self.add_child.call_deferred(shadow_polygon)
