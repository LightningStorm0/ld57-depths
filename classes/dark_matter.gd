class_name DarkMatter extends Polygon2D

static var dark_matter_material := preload("res://shaders/dark_matter.tres")

func _ready() -> void:
	z_index = 1
	
	material = dark_matter_material
	
	var area : Area2D = Area2D.new()
	
	area.gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE
	area.gravity = -100.0
	
	self.add_child(area)
	
	var collision : CollisionPolygon2D = CollisionPolygon2D.new()
	collision.polygon = self.polygon
	
	area.add_child(collision)
	
	area.body_entered.connect(in_dark_matte)
	area.body_exited.connect(exit_dark_matte)


func in_dark_matte(body : Node2D):
	if body is Climber:
		body.in_dark_matter += 1


func exit_dark_matte(body : Node2D):
	if body is Climber:
		body.in_dark_matter -= 1
