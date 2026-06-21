extends State
class_name Fall

@export var player: CharacterBody2D
@export var animation = &"Cair_Final"
@export var animation_final = &"Pular"
 
const SPEED   := 80.0
const GRAVITY := 400.0

func update(_delta: float) -> void:
	pass
 
func physics_update(delta: float) -> void:	
	var direction := Input.get_axis("left", "right") #Movimento horizontal durante a queda
	if direction != 0:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
 	
	player.velocity.y += GRAVITY * delta #Gravidade aplicada
 		
	player.animate(animation_final)
 	
	if player.is_on_floor(): #Voltou para o chão, troca para MOVE
		player.velocity.y = 0
		player.animate(animation)

		if Input.is_action_pressed("down"):
			transitioned.emit(self, "crouch")
		else:
			await get_tree().create_timer(0.05).timeout
			transitioned.emit(self, "idle")
	
	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
	
	if Input.is_action_pressed("pogo-attack") and Input.is_action_pressed("down"):
		transitioned.emit(self, "pogo")
	if Input.is_action_pressed("up") and player.canClimb: #Caso pressione Cima e esteja em contato com a corda
		transitioned.emit(self, "climb")
 
	player.move_and_slide()
