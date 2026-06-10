extends Node

@export var score: int

@export var health: int
@export var healthCap: int 

@export var lifes: int
@export var lifesCap: int

#Falta score central
#Falta timer == 500

func AddScore(points: int) -> void:
	score += points

func RemoveScore(points:int) -> void:
	var tempScore = score - points
	if score <= 0:
		score = 0
	else:
		score = tempScore

func ResetScore() -> void:
	score = 0

func CauseDamage(damage: int) -> void:
	var tempHealth = health - damage
	if health <= 0:
		#CALL DEATH
		pass
	else:
		health = tempHealth
	
func ReceiveCure(cure: int) -> void:
	var tempHealth = health + cure
	if tempHealth >= healthCap:
		health = healthCap
	else:
		health = tempHealth

func LoseLife() -> void:
	var tempLifes = lifes - 1
	if tempLifes <= 0:
		lifes = 0
		#GAMEOVER
		pass
	else:
		lifes = tempLifes
		#RESET STAGE
		pass

func resetLifes() -> void:
	lifes = lifesCap
