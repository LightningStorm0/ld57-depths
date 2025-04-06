class_name StaticPlatform extends Platform

func _ready() -> void:
	super._ready()
	
	var static_body : StaticBody2D = StaticBody2D.new()
	var collision_polygon : CollisionPolygon2D = CollisionPolygon2D.new()
	
	collision_polygon.polygon = self.polygon
	
	self.add_child.call_deferred(static_body)
	static_body.add_child.call_deferred(collision_polygon)
