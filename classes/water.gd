class_name Water extends Polygon2D

static var water_material := preload("res://shaders/water.tres")

func _ready() -> void:
	material = water_material
	
	var area : Area2D = Area2D.new()
	
	area.gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE
	area.gravity = -100.0
	
	self.add_child(area)
	
	var collision : CollisionPolygon2D = CollisionPolygon2D.new()
	collision.polygon = self.polygon
	
	area.add_child(collision)
	
	area.body_entered.connect(in_water)
	area.body_exited.connect(exit_water)


func in_water(body : Node2D):
	if body is Climber:
		body.in_water += 1


func exit_water(body : Node2D):
	if body is Climber:
		body.in_water -= 1
