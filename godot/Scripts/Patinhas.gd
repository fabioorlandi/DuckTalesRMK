extends CharacterBody2D

@export var canClimb: bool
@export var lastDir = "right"

var attacking: bool = false
var onRope: bool = false
var ropeX: float

func _ready() -> void:
	self.add_collision_exception_with($PogoCollision/CharacterBody2D)

func _process(delta: float) -> void:
	if lastDir == "left":
		$AnimatedSprite2D.flip_h = true
		$RayCast2D.scale.x = scale.y * -1
	elif lastDir == "right":
		$AnimatedSprite2D.flip_h = false
		$RayCast2D.scale.x = scale.y * 1

func animate(animation: String):
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.play()

func SetClimb(status: bool, posX: float) -> void:
	canClimb = status
	ropeX = posX

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		return
	
	if body is PhysicsBody2D and body.has_signal("destroy_on_collision"):
		body.emit_signal("destroy_on_collision", Vector2.ZERO)
		
	if body is PhysicsBody2D and body.has_signal("die_on_collision"):
		body.emit_signal("die_on_collision")
