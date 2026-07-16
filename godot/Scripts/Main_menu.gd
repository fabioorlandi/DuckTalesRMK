extends Node

@onready var timer: Timer = $Timer

var canChangeDifficulty: bool = true
var selectedDifficulty: String

var arrowPosX: float = 82.0

func _ready() -> void:
	AudioManager.play_background_music(load("res://Sounds/01_-_DuckTales_-_NES_-_DuckTales_Theme.ogg"))
	
	arrowPosX = 82.0
	selectedDifficulty = "normal"
	$Arrow.global_position = Vector2(82.0, 133.0)
	
	timer.start()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"))\
		and canChangeDifficulty:
		AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (16).wav"))
	
	if Input.is_action_just_pressed("left") and canChangeDifficulty:
		if arrowPosX == 82.0:
			$Arrow.global_position = Vector2(34.0, 133.0)
			arrowPosX = 34.0
			selectedDifficulty = "easy"
		elif arrowPosX == 146.0:
			$Arrow.global_position = Vector2(82.0, 133.0)
			arrowPosX = 82.0
			selectedDifficulty = "normal"
	if Input.is_action_just_pressed("right") and canChangeDifficulty:
		if arrowPosX == 34.0:
			$Arrow.global_position = Vector2(82.0, 133.0)
			arrowPosX = 82.0
			selectedDifficulty = "normal"
		elif arrowPosX == 82.0:
			$Arrow.global_position = Vector2(146.0, 133.0)
			arrowPosX = 146.0
			selectedDifficulty = "hard"
	if Input.is_action_just_pressed("pause"):
		canChangeDifficulty = false
		
		GamePoints.actualDifficulty = selectedDifficulty
		GamePoints.ResetGamepoints()
		
		AudioManager.stop_background_music()
		
		$Fade.DoFadeOutToScene("res://Level_select.tscn")

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("blink")
	await get_tree().create_timer(0.3).timeout
	$AnimatedSprite2D.play("default")
	
