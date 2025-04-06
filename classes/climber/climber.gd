class_name Climber extends CharacterBody2D

@export var die_velocity : float = 120.0

@export var top_speed : float = 60.0
@export var acceleration : float = 240.0
@export var drag : float = 180.0

@export var gravity : float = 200.0
@export var wall_slide_influence : float = 3.0

@export var jump_force : float = 70.0
@export var x_velocity_jump_boost : float = 1.2

@export var buffer_time_amount : float = 0.1
var buffer_time : float = 0.0

@export var coyote_time_amount : float = 0.1
var coyote_time : float = 0.0

var last_velocity : Vector2 = Vector2(0, 0)

var step_time : float = 0.3
var last_step : float = 0.0

var last_checkpoint : Vector2 = Vector2(0, 0)

@export var water_force : float = 0.5
@export var water_accel : float = 150.0
@export var water_drag : float = 50.0
@export var water_accel_vertical : float = 200.0

@export var water_max_down_speed : float = 20.0
@export var water_max_up_speed : float = 20.0
@export var water_max_speed : float = 30.0

@export var dark_matter_gravity : float = 60.0
@export var dark_matter_movement : float = 40.0

var in_water : int = 0
var in_dark_matter : int = 0

var water_sounds : Array[AudioStreamWAV] = [
	preload("res://audio/water/water1.wav"),
	preload("res://audio/water/water2.wav"),
	preload("res://audio/water/water3.wav"),
	preload("res://audio/water/water4.wav"),
	preload("res://audio/water/water5.wav"),
	preload("res://audio/water/water6.wav")
]

var deaths : int = 0

var timer : int = 0
var running : bool = false

func _ready() -> void:
	for c in $"../Checkpoints".get_children():
		if c is Checkpoint:
			if c.start_here:
				global_position = c.global_position + Vector2(0, -5)
				$"../Camera2D".position_y = self.global_position.y
				
				$"../Camera2D".dev_start_sequence()
	
	last_checkpoint = global_position
	$RespawnTimer.timeout.connect(respawn)

var checkpoints_inside : Array[Checkpoint] = []

var water_frame : int = 0

func _physics_process(delta: float) -> void:	
	var input_vector : Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if input_vector != Vector2(0, 0):
		running = true
	
	if running:
		timer += 1
	
	if Input.is_action_just_pressed("up"):
		buffer_time = buffer_time_amount
	else:
		buffer_time -= delta
	
	
	## Y VELOCITY STUFF
	if is_on_floor() and not in_water > 0:
		if last_velocity.length() != 0.0:
			if (last_velocity * get_floor_normal()).length() > die_velocity:
				print(get_floor_normal())
				die(get_floor_normal())
				return
			else:
				velocity.y = get_floor_normal().dot((velocity * Vector2(0, 1)).normalized()) * velocity.x * 0.5
		
		coyote_time = coyote_time_amount
	else:
		if is_on_wall():
			if last_velocity.length() != 0.0:
				if (last_velocity * get_wall_normal()).length() > die_velocity:
					die(get_wall_normal())
					return
				else:
					velocity.x = get_wall_normal().dot((velocity * Vector2(0, 1)).normalized()) * velocity.y
					velocity.y *= 1 - (abs(get_wall_normal().dot((velocity * Vector2(0, 1)).normalized())) * delta * wall_slide_influence)
			
			if not in_dark_matter > 0:
				velocity.y += gravity * delta
		else:
			if not in_dark_matter > 0:
				velocity.y += gravity * delta
			
			coyote_time -= delta
	
	
	## X VELOCITY STUFF
	if is_on_floor() and not in_water > 0 and not in_dark_matter > 0:
		if input_vector.x == 0:
			var applied_drag : float = drag * delta * signf(velocity.x)
			
			if signf(velocity.x) == signf(velocity.x - applied_drag):
				velocity.x -= applied_drag
			else:
				velocity.x = 0
		else:
			var x_change : float = input_vector.x * acceleration * delta
			
			if velocity.x + x_change > velocity.x and velocity.x + x_change > top_speed:
				velocity.x = max(velocity.x, top_speed)
			
			elif velocity.x + x_change < velocity.x and velocity.x + x_change < -top_speed:
				velocity.x = min(velocity.x, top_speed)
			
			else:
				velocity.x += x_change
	
	
	## JUMPING
	if coyote_time > 0 and buffer_time > 0 and not in_water > 0:
		coyote_time = 0
		buffer_time = 0
		
		$Jump.play()
		
		velocity.y -= jump_force
		velocity.x *= x_velocity_jump_boost
	
	
	## WATER
	if in_water > 0:
		if velocity.x != 0:
			$AnimatedSprite2D.scale.x = -signf(velocity.x)
		
		$Water.volume_db = 5.0 + min(velocity.length() * 0.1, 10.0)
		
		if velocity.length() > 30.0:
			if water_frame == 0:
				$Water.stream = water_sounds.pick_random()
				$Water.play()
				water_frame = 10
			else:
				water_frame -= 1
		else:
			water_frame = 0
		
		velocity.y -= gravity * delta * (1.0 - water_force)
		
		velocity.y += delta * water_accel_vertical * input_vector.y
		
		if input_vector.x == 0:
			var applied_drag : float = water_drag * delta * signf(velocity.x)
			
			if signf(velocity.x) == signf(velocity.x - applied_drag):
				velocity.x -= applied_drag
			else:
				velocity.x = 0
		else:
			velocity.x += delta * water_accel * input_vector.x
		
		velocity.y = clamp(velocity.y, -water_max_up_speed, water_max_down_speed)
		velocity.x = clamp(velocity.x, -water_max_speed, water_max_speed)
	
	## DARK MATTER
	if in_dark_matter > 0:
		velocity.y += dark_matter_gravity * delta
		
		velocity.y += dark_matter_movement * input_vector.y * delta
		velocity.x += dark_matter_movement * input_vector.x * delta
	
	
	## VISUALS
	if is_on_floor() and not in_water > 0:
		if abs(velocity.x) > 0.1:
			if $AnimatedSprite2D.animation != "walk": $AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.scale.x = -signf(velocity.x)
		else:
			$AnimatedSprite2D.animation = "idle"
	else:
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "jump_up"
		else:
			$AnimatedSprite2D.animation = "jump_down"
	
	
	## STEP SOUNDS
	if is_on_floor() and not in_water > 0:
		last_step -= delta
		
		if abs(velocity.x) > 0:
			if last_step < 0:
				last_step = step_time
				$Steps.play()
	else:
		last_step = 0
	
	
	## CHECKPOINT STUFF
	if is_on_floor():
		for c in checkpoints_inside:
			if not c.tagged:
				c.tag()
				last_checkpoint = c.global_position + Vector2(0, -5)
	
	
	last_velocity = velocity
	move_and_slide()


func create_corpse(corpse_position : Vector2):
	new_corpse = corpse.instantiate()
	new_corpse.global_position = corpse_position
	new_corpse.velocity.x = last_velocity.x
	new_corpse.velocity.y = last_velocity.y * 0.5
	
	for c in new_corpse.get_children():
		if c is Marker2D:
			$"../Camera2D".follow = c
	
	self.get_parent().add_child.call_deferred(new_corpse)


var corpse := preload("res://corpse/corpse.tscn")
var grave := preload("res://stuff/grave.tscn")

var new_grave : Node2D
var new_corpse : Node2D


func create_grave(grave_position : Vector2, normal : Vector2):
	new_grave = grave.instantiate()
	new_grave.global_position = grave_position
	new_grave.rotation = normal.angle() + (PI/2.0)
	
	self.get_parent().add_child(new_grave)


func disappear():
	deaths += 1
	
	hide()
	global_position = last_checkpoint
	set_physics_process(false)
	set_collision_layer_value(1, false)
	$RespawnTimer.start()


func spike(killed_by : Spike):
	if visible:
		create_corpse(self.global_position)
		create_grave(killed_by.global_position, Vector2(0, -1))
		disappear()


func kill(killed_by : KillArea):
	if visible:
		create_corpse(self.global_position)
		create_grave(self.global_position, Vector2(0, -1))
		disappear()


func die(floor_normal : Vector2):
	create_corpse(self.global_position)
	create_grave(self.global_position, floor_normal)
	disappear()


func respawn():
	new_corpse.queue_free.call_deferred()
	
	global_position = last_checkpoint
	velocity = Vector2(0, 0)
	last_velocity = Vector2(0, 0)
	
	checkpoints_inside = []
	
	set_physics_process(true)
	set_collision_layer_value(1, true)
	show()
	$"../Camera2D".follow = self
