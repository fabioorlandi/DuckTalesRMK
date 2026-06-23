extends Node

@onready var sprites: Array[Sprite2D] = [
	$HP/hp1,
	$HP/hp2,
	$HP/hp3,
	$HP/hp4,
	$HP/hp5
]

@onready var stagePointsLabel = $"$Stage/Points"
@onready var totalPointsLabel = $"$Total/Points"

@onready var lifesLabel = $Lifes

@onready var timerLabel = $Time/Timer
@onready var timer: Timer = $Time/StageTimer

@export var score: int

@export var totalScore: int

@export var health: int
@export var healthCap: int 

@export var lifes: int
@export var lifesCap: int

var timeLeft: int = 500

#Falta score central
#Falta timer == 500

func _ready():
	
	ResetHealth()
	ResetLifes()
	
	stagePointsLabel.text = str(score)
	totalPointsLabel.text = str(totalScore)
	
	lifesLabel.text = "P. " + str(lifes)
	
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	timerLabel.text = str(timeLeft)
	
func _process(delta):
	if Input.is_action_just_pressed("e"):
		RemoveScore(100)
	if Input.is_action_just_pressed("r"):
		AddScore(200)
	if Input.is_action_just_pressed("t"):
		AddToTotalScore()
	if Input.is_action_just_pressed("y"):
		CauseDamage(1)
	if Input.is_action_just_pressed("u"):
		ReceiveCure(1)
	if Input.is_action_just_pressed("i"):
		LoseLife()
	if Input.is_action_just_pressed("o"):
		ResetLifes()
	if Input.is_action_just_pressed("m"):
		get_tree().reload_current_scene()

func AddScore(points: int) -> void:
	score += points
	stagePointsLabel.text = str(score)

func RemoveScore(points:int) -> void:
	var tempScore = score - points
	if score <= 0:
		score = 0
	else:
		score = tempScore
	
	stagePointsLabel.text = str(score)

func ResetScore() -> void:
	score = 0
	stagePointsLabel.text = str(score)

func AddToTotalScore() -> void:
	totalScore += score
	totalPointsLabel.text = str(totalScore)

func CauseDamage(damage: int) -> void:
	var tempHealth = health - damage
	if health <= 0:
		#CALL DEATH
		pass
	else:
		health = tempHealth
	
	HealthSpritesUpdate()
	
func ReceiveCure(cure: int) -> void:
	var tempHealth = health + cure
	if tempHealth >= healthCap:
		health = healthCap
	else:
		health = tempHealth
	
	HealthSpritesUpdate()

func ResetHealth() -> void:
	#health = healthCap
	HealthSpritesUpdate()

func HealthSpritesUpdate() -> void:
	for i in range(sprites.size()):
		if i < healthCap:
			if i < health:
				HealthToSprite(i, 9)
			else:
				HealthToSprite(i, 0)
		elif i >= healthCap:
			HealthToSprite(i, 18)

func HealthToSprite(index: int, position: int) -> void:
	var rect = sprites[index].region_rect
	rect.position.y = position
	sprites[index].region_rect = rect
	
func LoseLife() -> void:
	var tempLifes = lifes - 1
	if tempLifes <= 0:
		lifes = 0
		lifesLabel.text = "P. " + str(lifes)
		#GAMEOVER
		pass
	else:
		lifes = tempLifes
		lifesLabel.text = "P. " + str(lifes)
		#RESET STAGE
		pass

func ResetLifes() -> void:
	lifes = lifesCap
	lifesLabel.text = "P. " + str(lifes)

func StopTimer() -> void:
	timer.stop()
	timerLabel.text = "0"

func ResetTimer() -> void:
	timer.stop()
	timeLeft = 500
	timerLabel.text = str(timeLeft)
	timer.start()

func AddTime(amount: int) -> void:
	timeLeft += amount
	if timeLeft >= 500:
		timeLeft = 500
	timerLabel.text = str(timeLeft)

func _on_timer_timeout():
	timeLeft -= 1	
	timerLabel.text = str(timeLeft)
	
	if timeLeft <= 0:
		timer.stop()
		timerLabel.text = "0"
		#GAMEOVER
