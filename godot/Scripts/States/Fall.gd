extends State
class_name Fall

@export var player: CharacterBody2D
@export var animation = &"Cair_Final"
@export var animation_2 = &"Pular"
 
const SPEED   := 80.0
const GRAVITY := 400.0

func update(_delta: float) -> void:
	pass
 
func _physics_update(delta: float) -> void:	
	var direction := Input.get_axis("left", "right") #Movimento horizontal durante a queda
	if direction != 0:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
 	
	player.velocity.y += GRAVITY * delta #Gravidade aplicada
 
	animate(animation_2, direction)
	player.move_and_slide()
 	
	if player.is_on_floor(): #Voltou para o chão, troca para MOVE
		player.velocity.y = 0
		animate(animation, direction)
		
		
		if Input.is_action_pressed("down"):
			transitioned.emit(self, "crouch")
		else:
			await get_tree().create_timer(0.05).timeout
			transitioned.emit(self, "idle")
		
	if Input.is_action_pressed("pogo") and Input.is_action_pressed("down"):
		transitioned.emit(self, "pogo")
	if Input.is_action_just_pressed("up"): #adicionar que se estiver em contato com a corta ================
		transitioned.emit(self, "climb")
 
