extends State
class_name Move

@export var player: CharacterBody2D
@export var animation = &"Caminhar"
 
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
		transitioned.emit(self, "jump")
 
func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.GRAVITY * delta #Aplica constantemente a gravidade para manter na plataforma
		if player.velocity.y > 0: #Caso não esteja pulando e comece a cair
			transitioned.emit(self, "fall")
			return

	var direction := Input.get_axis("left", "right")
	if direction != 0 or (Input.is_action_pressed("left") and Input.is_action_pressed("right")):
		var inferred_direction = -1 if player.lastDir == "left" else 1
		player.velocity.x = inferred_direction * player.SPEED

		if Input.is_action_pressed("down"):
			transitioned.emit(self, "crouch")
	elif Input.is_action_pressed("down"):
		transitioned.emit(self, "crouch")
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED) #Desaceleração suave ao soltar o botão
		transitioned.emit(self, "idle")
 
	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"

	player.animate(animation)
	player.move_and_slide()

	var collider_normal = player.attack_raycast.get_collision_normal()
	var collider = player.attack_raycast.get_collider()
	if collider and collider_normal.x == direction * -1:
		transitioned.emit(self, "prepare_attack")
