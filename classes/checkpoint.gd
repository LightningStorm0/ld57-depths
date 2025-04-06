class_name Checkpoint extends Area2D

@export var start_here : bool = false
@export var tagged : bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	
	body_entered.connect(entered)
	body_exited.connect(exited)

func tag():
	$AnimatedSprite2D.play("tag")
	tagged = true
	$AudioStreamPlayer2D.play()

func entered(body : Node2D):
	if body is Climber:
		body.checkpoints_inside.append(self)

func exited(body : Node2D):
	if body is Climber:
		body.checkpoints_inside.erase(self)
