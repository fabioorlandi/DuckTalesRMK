extends Node

@onready var timer: Timer = $Timer

var canChangeDifficulty: bool = true
var selectedDifficulty: String

var arrowPosX: float = 82.0

func _ready() -> void:
	arrowPosX = 82.0
	selectedDifficulty = "normal"
	$Arrow.global_position = Vector2(82.0, 133.0)
	
	timer.start()

func _process(delta: float) -> void:
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
		
		get_tree().change_scene_to_file("res://Level_select.tscn")

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("blink")
	await get_tree().create_timer(0.3).timeout
	$AnimatedSprite2D.play("default")
	
