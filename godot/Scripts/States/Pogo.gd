extends State
class_name Pogo
 
@export var player: CharacterBody2D
@export var animation = &"Pogo_Inicio"
@export var animation_2 = &"Pogo_Final"
 
const SPEED       := 80.0
const GRAVITY     := 600.0
const POGO_FORCE  := -280.0  #Força do quique 

func enter() -> void:
	$"../../PogoCollision/CollisionShape2D".disabled = false

func exit() -> void:
	$"../../PogoCollision/CollisionShape2D".disabled = true

func update(_delta: float) -> void:
	if Input.is_action_just_released("pogo-attack") or Input.is_action_just_released("down"): #Soltou o botão de pogo volta a cair normalmente em fall
		transitioned.emit(self, "fall")
 
func physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
 
	player.velocity.y += GRAVITY * delta
 
	player.animate(animation)
	player.move_and_slide()
 	
	if player.is_on_floor() and Input.is_action_pressed("pogo-attack"): #Tocou no chão/objeto segurando pogo quica de novo
		player.animate(animation_2)
		await get_tree().create_timer(0.05).timeout

		player.velocity.y = POGO_FORCE

	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
	
	if not Input.is_action_pressed("pogo-attack") or not Input.is_action_pressed("down"):
		if player.velocity.y > 0: #Soltou enquanto estava no ar volta para fall
			transitioned.emit(self, "fall")
 
