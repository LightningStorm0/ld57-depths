extends AudioStreamPlayer

var songs : Array[AudioStreamWAV] = [
	preload("res://audio/soundtrack/LD57 - on top of the world.wav"),
	preload("res://audio/soundtrack/LD57 - ultimatum.wav"),
	preload("res://audio/soundtrack/LD57 - for all time.wav")
]

var index : int = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_music"):
		if playing:
			playing = false
		else:
			next_song()

func _ready() -> void:
	stream = songs[index]
	
	play()
	
	finished.connect(next_song)

func next_song() -> void:
	index += 1
	
	index = index % songs.size()
	
	stream = songs[index]
	
	play()
