extends State
class_name Pogo
 
@export var player: CharacterBody2D
@export var animation = &"Pogo_Inicio"
@export var animation_2 = &"Pogo_Final"

func update(_delta: float) -> void:
	if Input.is_action_just_released("pogo-attack") or Input.is_action_just_released("down"): #Soltou o botão de pogo volta a cair normalmente em fall
		transitioned.emit(self, "fall")
 
func physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
 
	player.velocity.y += player.POGO_GRAVITY * delta

	player.animate(animation)
	player.move_and_slide()

	if Input.is_action_pressed("pogo-attack"):
		var collider_interative = player.interactive_pogo_shapecast.get_collider(0)
		var collider_floor = player.floor_pogo_shapecast.get_collider(0)
		if collider_interative:
			if collider_interative is PhysicsBody2D and collider_interative.has_signal("destroy_on_collision"):
				collider_interative.emit_signal("destroy_on_collision", Vector2.ZERO)
		
			if collider_interative is PhysicsBody2D and collider_interative.has_signal("die_on_collision"):
				collider_interative.emit_signal("die_on_collision")

			if can_pogo_bounce(collider_interative) or collider_floor:
				player.animate(animation_2)
				await get_tree().create_timer(0.05).timeout

				player.velocity.y = player.POGO_FORCE
			else:
				transitioned.emit(self, "crouch")
		elif player.is_on_floor():
			transitioned.emit(self, "crouch")

	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
	
	if not Input.is_action_pressed("pogo-attack") or not Input.is_action_pressed("down"):
		if player.velocity.y < 0: #Soltou enquanto estava no ar volta para fall
			player.velocity.y = 0
			transitioned.emit(self, "fall")
 
func can_pogo_bounce(body: Object) -> bool:
	return body.has_method("is_pogo_interactive") and body.is_pogo_interactive()
