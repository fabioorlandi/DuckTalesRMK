extends State
class_name Prepare_Attack

@export var player: CharacterBody2D
@export var animation = &"Preparar_Tacada"

func update(_delta: float) -> void:
	if player.collisionWithEnemy and player.takingDamage:
		transitioned.emit(self, "damage")

func physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var lastDir = player.lastDir
	
	var collider_normal = player.attack_raycast.get_collision_normal()
	var collision = player.get_last_slide_collision()
	if collision:
		var body = collision.get_collider()
		#Garante que está se movendo em direção à colisão
		if body and collider_normal != Vector2.ZERO and collider_normal.x == direction * -1  and not body.is_in_group("Inimigos"):
			if Input.is_action_just_pressed("pogo-attack"):
				transitioned.emit(self, "attack")
			else:
				if (Input.is_action_pressed("left") and lastDir == "left") or (Input.is_action_pressed("right") and lastDir == "right"):
					player.animate(animation)

				if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
					transitioned.emit(self, "jump")
				if Input.is_action_just_pressed("down") and player.is_on_floor(): #Manda agachar
					transitioned.emit(self, "crouch")
		else:
			if direction != 0 or (Input.is_action_pressed("left") and Input.is_action_pressed("right")):
				transitioned.emit(self, "move")
			else:
				transitioned.emit(self, "idle")
			
			if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
				transitioned.emit(self, "jump")
			if Input.is_action_just_pressed("down") and player.is_on_floor(): #Manda agachar
				transitioned.emit(self, "crouch")
	else:
		if direction != 0 or (Input.is_action_pressed("left") and Input.is_action_pressed("right")):
			transitioned.emit(self, "move")
		else:
			transitioned.emit(self, "idle")
		
		if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
			transitioned.emit(self, "jump")
		if Input.is_action_just_pressed("down") and player.is_on_floor(): #Manda agachar
			transitioned.emit(self, "crouch")

	player.move_and_slide()

	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"	
