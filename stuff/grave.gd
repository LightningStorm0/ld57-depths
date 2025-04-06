extends Node2D

func _ready() -> void:
	hide()
	
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		var hitting : Object =  $RayCast2D.get_collider()
		
		if hitting is Climber:
			$RayCast2D.add_exception(hitting)
			
			$RayCast2D.force_raycast_update()
			
			if $RayCast2D.is_colliding():
				self.reparent($RayCast2D.get_collider())
		else:
			self.reparent($RayCast2D.get_collider())
	
	$Timer.timeout.connect(show)
