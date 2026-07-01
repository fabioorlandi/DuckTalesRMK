extends State
class_name Jump

@export var player: CharacterBody2D
@export var animation = &"Pular"

func enter() -> void:
	player.velocity.y = player.JUMP_FORCE #Aplica a força do pulo ao entrar no estado
 
func update(_delta: float) -> void:	
	if Input.is_action_just_released("jump") and player.velocity.y < 0: #Pulo curto
		player.velocity.y *= player.JUMP_CUT
 
func physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right") #Controle horizontal no ar
	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
 	
	player.velocity.y += player.GRAVITY * delta #Aplica gravidade

	player.animate(animation)
	player.move_and_slide()
 	
	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"

	if Input.is_action_pressed("pogo-attack") and Input.is_action_pressed("down"):
		transitioned.emit(self, "pogo")
	if Input.is_action_pressed("up") and player.canClimb: #Caso pressione Cima e esteja em contato com a corda
		transitioned.emit(self, "climb")

	if player.velocity.y > 0: #Quando a velocidade vertical vira positiva troca pra fall
		transitioned.emit(self, "fall")
	if player.is_on_ceiling(): #Caso toque no teto encerra o incremento do jump
		player.velocity.y = 0
