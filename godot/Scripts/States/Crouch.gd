extends State
class_name Crouch

@export var player: CharacterBody2D
@export var animation = &"Abaixar"

var crouched = false

func enter() -> void:
	$"../../CollisionShape2D".disabled = true
	$"../../CrouchCollisionShape2D".disabled = false
	player.velocity.x = 0
	crouched = false

func exit() -> void:
	$"../../CrouchCollisionShape2D".disabled = true
	$"../../CollisionShape2D".disabled = false

func update(_delta: float) -> void:
	if player.collisionWithEnemy and player.takingDamage:
		transitioned.emit(self, "damage")

func physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_just_released("down"): #Sai do agachar
		if direction != 0:
			transitioned.emit(self, "move")
		else:
			transitioned.emit(self, "idle")
			
	if not player.is_on_floor():
		transitioned.emit(self, "fall")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
		transitioned.emit(self, "jump")
	
	if not crouched:
		player.animate(animation)
		crouched = true
		
	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
	
	player.move_and_slide()
