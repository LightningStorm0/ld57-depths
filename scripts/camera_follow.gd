extends Camera2D

@export var follow : Node2D
@export var speed : float = 3.0

var top_speed : float = 100

@export var dev_start : bool = false

var position_y : float = 0.0


func _ready() -> void:
	position_y = self.global_position.y
	
	$Counter.hide()
	
	if dev_start: dev_start_sequence()

func dev_start_sequence() -> void:
	follow = $"../Climber"
	counter()
	position_y = follow.global_position.y

var max_meters : int = 0
var start_y : float = 0.0
var factor : float = 1.0 

func _physics_process(delta : float) -> void:
	if follow:
		position_y += clamp((follow.global_position.y - position_y) * delta * 10.0, -top_speed * delta, top_speed * delta)
	
	global_position.y = round(position_y * 2.0) / 2.0
	
	#global_position.y = position_y
	
	if follow is Climber:
		max_meters = max(max_meters, (follow.global_position.y - start_y) * factor)
		
		var max_string : String = str(max_meters)
		while max_string.length() < 4: max_string = "0" + max_string
		
		$Counter/AnimatedSprite2D.play(max_string[0])
		$Counter/AnimatedSprite2D2.play(max_string[1])
		$Counter/AnimatedSprite2D3.play(max_string[2])
		$Counter/AnimatedSprite2D4.play(max_string[3])


func _on_timer_timeout() -> void:
	counter()
	follow = $"../Climber"
	
	if follow is Climber:
		start_y = follow.global_position.y


func counter():
	$Counter.show()
