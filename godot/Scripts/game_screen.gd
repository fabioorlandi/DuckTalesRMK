extends Node2D

var currentLevelSong = "res://Sounds/04_-_DuckTales_-_NES_-_Transylvania.ogg"

@export var player: PackedScene

@export var actualCheckpoint: int

@export var checkpoints := PackedVector2Array([

])

func _ready() -> void:
	AudioManager.play_background_music(load(currentLevelSong))

func ResetPlayer() -> void:
	if $Camera2D/UI.lifes > 0:
			$Camera2D/UI.LoseLife()
			$Camera2D/UI.ResetHealth()
			$Camera2D/UI.ResetTimer()
			
			$Camera2D.global_position = Vector2(128,312)
			$Fade.global_position = Vector2(128,312)
			
			var obj = player.instantiate()
			obj.global_position = checkpoints[actualCheckpoint]
			get_tree().current_scene.add_child(obj)
			$Camera2D.player = obj
			$Camera2D.floorY = 312
			$Fade.player = obj
			$Camera2D/UI.player = obj
			
			if $Camera2D.onBoss:
				$Camera2D.onBoss = false
			
			# resetar pos da camera
			# verificar se perde ponto quando morre
			
			$Fade.DoFadeOut()
			
	elif $Camera2D/UI.lifes <= 0:
		GamePoints.ResetGamepoints()
		get_tree().change_scene_to_file("res://main_menu.tscn")
