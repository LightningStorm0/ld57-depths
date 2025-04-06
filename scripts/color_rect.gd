extends ColorRect

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_crt"):
		visible = !visible
