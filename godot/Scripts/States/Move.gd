extends State
class_name Move

@export var player: CharacterBody2D
@export var animation = &"Caminhar"
 
const SPEED := 80.0
const GRAVITY := 400.0
  
func update(_delta: float) -> void:	
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
		transitioned.emit(self, "jump")
 
func _physics_update(delta: float) -> void:	
	if not player.is_on_floor():
		player.velocity.y += GRAVITY * delta #Aplica constantemente a gravidade para manter na plataforma
		if player.velocity.y > 0: #Caso não esteja pulando e comece a cair
			transitioned.emit(self, "fall")
			return
 
	var direction := Input.get_axis("left", "right")
 
	if direction != 0:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED) #Desaceleração suave ao soltar o botão
		transitioned.emit(self, "idle")
 
	animate(animation, direction < 0)
	player.move_and_slide()
 
