class_name Spike extends Area2D

func _ready() -> void:
	body_entered.connect(kill)

func kill(body : Node2D) -> void:
	if body is Climber:
		body.spike(self)
