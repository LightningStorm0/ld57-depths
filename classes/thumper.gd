class_name Thumper extends Node

var RB : RigidBody2D
var audio : AudioStreamPlayer

func _ready() -> void:
	var p := self.get_parent()
	
	if p is RigidBody2D:
		RB = p
		
		p.contact_monitor = true
		p.max_contacts_reported = 1
		p.body_entered.connect(thump)
	
	audio = AudioStreamPlayer.new()
	
	audio.bus = "Physical"
	
	self.add_child(audio)

static var thumps : Array[AudioStreamWAV] = [
	preload("res://audio/thumps/thump1.wav"),
	preload("res://audio/thumps/thump2.wav"),
	preload("res://audio/thumps/thump3.wav"),
	preload("res://audio/thumps/thump4.wav"),
	preload("res://audio/thumps/thump5.wav"),
	preload("res://audio/thumps/thump6.wav"),
	preload("res://audio/thumps/thump7.wav")
]

func thump(body : Node):
	if RB:
		audio.volume_db = -60
		audio.volume_db += min(sqrt(RB.linear_velocity.length()) * 5.0, 40)
		
		audio.stream = thumps.pick_random()
		audio.play()
