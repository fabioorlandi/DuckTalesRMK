extends Node

@export var actualDifficulty: String

@export var totalScore: int

@export var health: int
@export var healthCap: int 

@export var lifes: int
@export var lifesCap: int

func ResetGamepoints() -> void:
	totalScore = 0
	health = 6
	healthCap = 6
	lifes = 2
	lifesCap = 2
