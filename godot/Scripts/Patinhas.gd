extends CharacterBody2D

@export var canClimb: bool
@export var lastDir = "right"
@onready var attack_raycast = $AttackRayCast2D
@onready var pogo_raycast = $PogoRayCast2D

var attacking: bool = false
var onRope: bool = false
var ropeX: float

func _process(delta: float) -> void:
	if lastDir == "left":
		$AnimatedSprite2D.flip_h = true
		attack_raycast.scale.x = scale.y * -1
	elif lastDir == "right":
		$AnimatedSprite2D.flip_h = false
		attack_raycast.scale.x = scale.y * 1

func animate(animation: String):
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.play()

func SetClimb(status: bool, posX: float) -> void:
	canClimb = status
	ropeX = posX
