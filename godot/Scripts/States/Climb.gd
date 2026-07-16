extends State
class_name Climb

@onready var animated = $"../../AnimatedSprite2D"
@export var player: CharacterBody2D
@export var animation = &"Escalar"

var cordaX: float
var offsetX: float = 4

@onready var camera = $"../../../Camera2D"

func enter() -> void:
	player.velocity = Vector2.ZERO
	player.onRope = true
	cordaX = player.ropeX
	
	camera.isFixedCamera = true
	
	if player.lastDir == "left":
		player.global_position.x = cordaX + offsetX
	elif player.lastDir == "right":
		player.global_position.x = cordaX - offsetX
	
func exit() -> void:
	animated.speed_scale = 1
	player.onRope = false
	
	camera.isFixedCamera = false
	
func update(delta: float) -> void:
	#seta o jogador com a posição x da corda -/+ offset
	if Input.is_action_pressed("left"):
		player.global_position.x = cordaX + offsetX
	if Input.is_action_pressed("right"):
		player.global_position.x = cordaX - offsetX
		
	if player.collisionWithEnemy and player.takingDamage:
		transitioned.emit(self, "damage")
	
func physics_update(delta: float) -> void:
	if Input.is_action_pressed("up"):
		AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (4).wav"), false)
		
		player.velocity.y = -1 * player.ROPE_SPEED
		animated.speed_scale = 1
	elif Input.is_action_pressed("down"):
		AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (4).wav"), false)
		
		player.velocity.y  = 1 * player.ROPE_SPEED
		animated.speed_scale = 1
	elif Input.is_action_just_released("up") or Input.is_action_just_released("down"):
		player.velocity.y = 0
		animated.speed_scale = 0
		
	player.animate(animation)
	player.move_and_slide()
	
	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
	
	if Input.is_action_pressed("jump") and not Input.is_action_pressed("up") and player.canClimb:
		transitioned.emit(self, "fall")
	if Input.is_action_pressed("down") and not player.canClimb:
		transitioned.emit(self, "fall")
	if not player.onRope:
		transitioned.emit(self, "fall")
