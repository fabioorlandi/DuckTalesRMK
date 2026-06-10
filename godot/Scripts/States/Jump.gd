extends State
class_name Jump

@export var player: CharacterBody2D
@export var animation = &"Pular"

const SPEED    := 80.0
const GRAVITY  := 400.0
const JUMP_FORCE := -200.0
const JUMP_CUT   := 0.25

func enter() -> void:
	player.velocity.y = JUMP_FORCE #Aplica a força do pulo ao entrar no estado
 
func update(_delta: float) -> void:	
	if Input.is_action_just_released("jump") and player.velocity.y < 0: #Pulo curto
		player.velocity.y *= JUMP_CUT
 
func physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right") #Controle horizontal no ar
	if direction != 0:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
 	
	player.velocity.y += GRAVITY * delta #Aplica gravidade
 
	animate(animation, direction)
	player.move_and_slide()
 	
	var collision = player.get_last_slide_collision()
	if collision:
		var body = collision.get_collider()
		print(body.get_class())

	if player.velocity.y > 0: #Quando a velocidade vertical vira positiva troca pra fall
		transitioned.emit(self, "fall")
		
	if Input.is_action_pressed("pogo") and Input.is_action_pressed("down"):
		transitioned.emit(self, "pogo")
	if Input.is_action_just_pressed("up"): #adicionar que se estiver em contato com a corta ================
		transitioned.emit(self, "climb")
	
	if player.is_on_ceiling(): #Caso toque no teto encerra o incremento do jump
		player.velocity.y = 0
