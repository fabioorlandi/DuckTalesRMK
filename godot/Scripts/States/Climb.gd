extends State
class_name Climb

@onready var animated = $"../../AnimatedSprite2D"

@export var player: CharacterBody2D

@export var animation = &"Escalar"

var cordaX: float
var offsetX: float

const SPEED := 50.0

func enter() -> void:
	#pega a posição x da corda
	pass

func update(delta: float) -> void:
	#seta o jogador com a posição x da corda -/+ offset
	if Input.is_action_pressed("left"):
		pass
	if Input.is_action_pressed("right"):
		pass
	
func _physics_update(delta: float) -> void:
	if Input.is_action_pressed("up"):
		player.velocity.y = -1 * SPEED
		animated.speed_scale = 1
	elif Input.is_action_pressed("down"):
		player.velocity.y  = 1 * SPEED
		animated.speed_scale = 1
	elif Input.is_action_just_released("up") or Input.is_action_just_released("down"):
		player.velocity.y = 0
		animated.speed_scale = 0
		
	var direction := Input.get_axis("left", "right")
	animate(animation, direction)
	player.move_and_slide()
	
	if Input.is_action_pressed("left") and Input.is_action_pressed("jump"):
		transitioned.emit(self, "fall")
	if Input.is_action_pressed("right") and Input.is_action_pressed("jump"):
		transitioned.emit(self, "fall")
