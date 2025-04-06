extends Node2D

@export var time : int = 0
@export var deaths : int = 0

func _ready() -> void:
	var deaths_string : String = str(deaths)
	while deaths_string.length() < 4: deaths_string = "0" + deaths_string
	
	var dtime : float = time / 60.0
	
	var time_hundredths : int = int(fmod(dtime, 1.0) * 100)
	
	dtime -= fmod(dtime, 1.0)
	
	var time_seconds : int = int(fmod(dtime, 60))
	
	dtime -= int(fmod(dtime, 60))
	
	var time_minutes : int = int(dtime / 60)
	
	var minutes_string : String = str(time_minutes)
	while minutes_string.length() < 2: minutes_string = "0" + minutes_string
	
	var seconds_string : String = str(time_seconds)
	while seconds_string.length() < 2: seconds_string = "0" + seconds_string
	
	var hundredths_string : String = str(time_hundredths)
	while hundredths_string.length() < 2: hundredths_string = "0" + hundredths_string
	
	$Deaths/AnimatedSprite2D.play(deaths_string[0])
	$Deaths/AnimatedSprite2D2.play(deaths_string[1])
	$Deaths/AnimatedSprite2D3.play(deaths_string[2])
	$Deaths/AnimatedSprite2D4.play(deaths_string[3])
	
	$Time/AnimatedSprite2D7.play(minutes_string[0])
	$Time/AnimatedSprite2D8.play(minutes_string[1])
	
	$Time/AnimatedSprite2D9.play(seconds_string[0])
	$Time/AnimatedSprite2D10.play(seconds_string[1])
	
	$Time/AnimatedSprite2D11.play(hundredths_string[0])
	$Time/AnimatedSprite2D12.play(hundredths_string[1])
