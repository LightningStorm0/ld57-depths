class_name MovingPlatform extends Platform

@export var can_crush : bool = true
@export var crush_buffer : float = 3.0

@export var time_to_go : float = 50.0
@export var pause_time : float = 1.0

@export var time : float = 0.0

var starting_position : Vector2 = Vector2(0, 0)
var second_position : Vector2 = Vector2(0, 0)

var first_position : bool = true

var distance = 1.0

func _ready() -> void:
	super._ready()
	
	starting_position = global_position
	
	for c in get_children():
		if c is PlatformMoveTo:
			second_position = c.global_position
	
	distance = second_position.distance_to(starting_position)
	
	var static_body : CharacterBody2D = CharacterBody2D.new()
	var collision_polygon : CollisionPolygon2D = CollisionPolygon2D.new()
	
	collision_polygon.polygon = self.polygon
	
	self.add_child.call_deferred(static_body)
	static_body.add_child.call_deferred(collision_polygon)
	
	if can_crush:
		var death_polygon : CollisionPolygon2D = CollisionPolygon2D.new()
		death_polygon.polygon = polygon
		
		var left : float = 0.0
		var right : float = 0.0
		
		for point in range(0, death_polygon.polygon.size()):
			var p_before : Vector2 = death_polygon.polygon[(point - 1) % death_polygon.polygon.size()]
			var p : Vector2 = death_polygon.polygon[point]
			var p_after : Vector2 = death_polygon.polygon[(point + 1) % death_polygon.polygon.size()]
			
			left += (p - p_before).angle_to(p_after - p)
			right += (p_after - p).angle_to(p - p_before)
		
		for point in range(0, death_polygon.polygon.size()):
			var p_before : Vector2 = death_polygon.polygon[(point - 1) % death_polygon.polygon.size()]
			var p : Vector2 = death_polygon.polygon[point]
			var p_after : Vector2 = death_polygon.polygon[(point + 1) % death_polygon.polygon.size()]
			
			var normal : Vector2 = ((p - p_before) + (p_after - p)).normalized()
			
			if left > right:
				normal = Vector2.from_angle(normal.angle() + PI/2)
			else:
				normal = Vector2.from_angle(normal.angle() - PI/2)
			
			death_polygon.polygon[point] += normal * crush_buffer
		
		left = 0.0
		right = 0.0
		
		for point in range(0, death_polygon.polygon.size()):
			var p_before : Vector2 = death_polygon.polygon[(point - 1) % (death_polygon.polygon.size() - 1)]
			var p : Vector2 = death_polygon.polygon[point]
			var p_after : Vector2 = death_polygon.polygon[(point + 1) % (death_polygon.polygon.size() - 1)]
			
			left += (p - p_before).angle_to(p_after - p)
			right += (p_after - p).angle_to(p - p_before)
		
		if abs(left) + abs(right) < 1.0:
			print("ERROR: " + name + " cannot form collision polygon")
			
			var second_polygon : Line2D = Line2D.new()
			second_polygon.width = 1.0
			second_polygon.points = death_polygon.polygon
			self.add_child(second_polygon)
		
		var kill_area : KillArea = KillArea.new()
		
		self.add_child(kill_area)
		
		kill_area.add_child(death_polygon)

func _physics_process(delta : float) -> void:
	if time <= 0:
		var move : Vector2
		
		if first_position:
			move = second_position - global_position
		else:
			move = starting_position - global_position
		
		move = move.limit_length(delta * (distance / time_to_go))
		
		global_position += move
		
		if move.length() < 0.01:
			time = pause_time
			first_position = !first_position
	else:
		time -= delta
