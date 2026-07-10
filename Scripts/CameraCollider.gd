extends Area2D

@onready var camera = $"../../Camera2D"

@export var FollowX: bool
@export var UnfollowX: bool

@export var Transition: bool
@export var TransitionPos: int

func _on_body_entered(body: Node2D) -> void:
	if FollowX == true and body.name == "Patinhas":
		camera.follow_x = true
	if UnfollowX == true and body.name == "Patinhas":
		camera.follow_x = false
	if Transition == true and body.name == "Patinhas":
		if camera.onTransition == false and camera.futurePos != TransitionPos:
			camera.onTransition = true
			camera.futurePos = TransitionPos
			camera.follow_y = true
