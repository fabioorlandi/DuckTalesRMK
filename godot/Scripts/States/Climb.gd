extends State
class_name Climb

@onready var animated = $"../../AnimatedSprite2D"

@export var player: CharacterBody2D

@export var animation = &"Escalar"

var cordaX: float
var offsetX: float = 4

const SPEED := 50.0

func enter() -> void:
	player.velocity = Vector2.ZERO
	cordaX = player.ropeX	
	if player.lastDir == "left":
		player.global_position.x = cordaX + offsetX
	elif player.lastDir == "right":
		player.global_position.x = cordaX - offsetX
	
func update(delta: float) -> void:
	#seta o jogador com a posição x da corda -/+ offset
	if Input.is_action_pressed("left"):
		player.global_position.x = cordaX + offsetX		
	if Input.is_action_pressed("right"):
		player.global_position.x = cordaX - offsetX		
	
func physics_update(delta: float) -> void:
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
	
	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
	
	if Input.is_action_pressed("left") and Input.is_action_pressed("jump"):
		transitioned.emit(self, "fall")
	if Input.is_action_pressed("right") and Input.is_action_pressed("jump"):
		transitioned.emit(self, "fall")
