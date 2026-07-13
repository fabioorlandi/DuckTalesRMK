extends Node2D

var currentLevelSong = "res://Sounds/04_-_DuckTales_-_NES_-_Transylvania.ogg"

func _ready() -> void:
	AudioManager.play_background_music(load(currentLevelSong))
