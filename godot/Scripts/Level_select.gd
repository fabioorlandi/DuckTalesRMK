extends Node2D

func _ready() -> void:
	AudioManager.play_background_music(load("res://Sounds/02_-_DuckTales_-_NES_-_Stage_Select.ogg"))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		AudioManager.stop_background_music()
		get_tree().change_scene_to_file("res://GameScreen.tscn")
