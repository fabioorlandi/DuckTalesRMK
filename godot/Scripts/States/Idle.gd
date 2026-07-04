extends State
class_name Idle

@export var player: CharacterBody2D
@export var animation = &"Parado"

func update(_delta: float) -> void:
	if player.get_damage_collision_with_enemy():
		transitioned.emit(self, "damage")

func physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		transitioned.emit(self, "move")
		
	if not player.is_on_floor():
		transitioned.emit(self, "fall")

	if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
		transitioned.emit(self, "jump")
	if Input.is_action_just_pressed("down") and player.is_on_floor(): #Manda agachar
		transitioned.emit(self, "crouch")
	
	if direction == 0:
		player.animate(animation)

	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"

	player.move_and_slide()
