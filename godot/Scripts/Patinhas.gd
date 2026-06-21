extends CharacterBody2D

@export var canClimb: bool
@export var lastDir = "right"

var attacking: bool = false
var onRope: bool = false
var ropeX: float

func _process(delta: float) -> void:
	if lastDir == "left":
		scale.x = scale.y * -1
	elif lastDir == "right":
		scale.x = scale.y * 1

func animate(animation: String):
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.play()

func SetClimb(status: bool, posX: float) -> void:
	canClimb = status
	ropeX = posX

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PhysicsBody2D and body.has_signal("destroy_on_collision"):
		body.emit_signal("destroy_on_collision", Vector2.ZERO)
