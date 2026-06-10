extends State
class_name Crouch

@export var player: CharacterBody2D
@export var animation = &"Abaixar"

func enter() -> void:
	player.velocity = Vector2.ZERO

func update(_delta: float) -> void:	
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_just_released("down"): #Sai do agachar
		if direction != 0:
			transitioned.emit(self, "move")
		else:
			transitioned.emit(self, "idle")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
		transitioned.emit(self, "jump")

func _physics_update(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	animate(animation, direction)
	player.move_and_slide()
	
	
