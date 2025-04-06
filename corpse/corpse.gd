extends Node2D

@export var velocity : Vector2 = Vector2(0, 0)

func _ready() -> void:
	for c in get_children():
		if c is RigidBody2D:
			c.linear_velocity = velocity
	
	$AudioStreamPlayer.max_polyphony = cracksleft

var time : float = 0.0

var cracksleft : int = 10

var cracks : Array[AudioStreamWAV] = [
	preload("res://audio/cracks/crack1.wav"),
	preload("res://audio/cracks/crack2.wav"),
	preload("res://audio/cracks/crack3.wav"),
	preload("res://audio/cracks/crack4.wav"),
	preload("res://audio/cracks/crack5.wav"),
	preload("res://audio/cracks/crack6.wav"),
	preload("res://audio/cracks/crack7.wav")
]

func _physics_process(delta : float) -> void:
	if cracksleft > 0:
		$AudioStreamPlayer.stream = cracks.pick_random()
		$AudioStreamPlayer.play()
		cracksleft -= 1
	
	time += delta
	
	var average : Vector2 = Vector2(0, 0)
	var count : int = 0
	
	for c in get_children():
		if c is RigidBody2D:
			average += c.global_position
			count += 1
			
			c.modulate.a = max(0, 1.0 - (time - 1.5) * 3.0)
			
			if c.linear_velocity.length() < 0.1 and time > 0.25:
				c.freeze = true
	
	$Position.global_position = (average + (global_position * 10.0)) / (count + 10.0)
