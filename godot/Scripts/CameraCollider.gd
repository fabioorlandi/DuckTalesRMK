extends Area2D

@onready var camera = $"../../Camera2D"

@export var posUp: float
@export var posDown: float

@export var screenLayer: int = 0

@export var blockDownToUp: bool

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		camera.TransitionCam(posUp, posDown, screenLayer, blockDownToUp)
