extends Area2D

var stats := preload("res://stats.tscn")

func _ready() -> void:
	set_physics_process(false)
	$"../../Camera2D/ColorRect".hide()

func _on_body_entered(body: Node2D) -> void:
	if body is Climber:
		body.running = false
		
		print(body.timer)
		
		$"../../Camera2D/ColorRect".show()
		
		set_physics_process(true)
		
		body.set_physics_process(false)


func _physics_process(delta: float) -> void:
	var change : Vector2 = self.global_position - $"../../Climber".position
	
	change = change.limit_length(delta * 1.0)
	
	change.x *= 2.0
	
	$"../../Climber".global_position += change
	$"../../Climber".scale *= 0.999
	
	$"../../Camera2D/ColorRect".color.a += delta * 0.25
	
	$"../../Camera2D/ColorRect".color.a = min($"../../Camera2D/ColorRect".color.a, 1)
	
	if ($"../../Camera2D/ColorRect".color.a) == 1:
		$"../Timer".start()
		$"../Timer".timeout.connect(show_screen)
		set_physics_process(false)


func show_screen():
		var stats_screen := stats.instantiate()
		
		stats_screen.time = $"../../Climber".timer
		stats_screen.deaths = $"../../Climber".deaths
		
		$"../..".get_parent().add_child(stats_screen)
		$"../..".queue_free.call_deferred()
