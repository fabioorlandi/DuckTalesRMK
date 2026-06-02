extends State
class_name Fall

@export var player: CharacterBody2D
 
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
 
	player.move_and_slide()
 	
	if player.is_on_floor(): #Voltou para o chão, troca para MOVE
		player.velocity.y = 0
		transitioned.emit(self, "move")
		
	if Input.is_action_just_pressed("pogo"):
		transitioned.emit(self, "pogo")
 
