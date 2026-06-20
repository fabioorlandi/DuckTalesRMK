extends CharacterBody2D

@export var canClimb: bool
var onRope: bool = false

var ropeX: float
var lastDir = "right"

func SetClimb(status: bool, posX: float) -> void:
	canClimb = status
	ropeX = posX
