class_name KillArea extends Area2D

func _ready() -> void:
	body_entered.connect(kill)

func kill(body : Node2D) -> void:
	if body is Climber:
		body.kill(self)
