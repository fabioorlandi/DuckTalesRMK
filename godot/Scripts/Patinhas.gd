extends CharacterBody2D

@export var canClimb: bool
var onRope: bool = false

var ropeX: float
var lastDir = "right"

func SetClimb(status: bool, posX: float) -> void:
	canClimb = status
	ropeX = posX

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PhysicsBody2D and body.has_signal("destroy_on_collision"):
		body.emit_signal("destroy_on_collision")
