extends State
class_name Idle

@export var player: CharacterBody2D
@export var animation = &"Parado"

func enter() -> void:
	animate(animation, 0)
	player.move_and_slide()

func update(_delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		transitioned.emit(self, "move")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): #Pula se pode pular
		transitioned.emit(self, "jump")
	if Input.is_action_just_pressed("down") and player.is_on_floor(): #Manda agachar
		transitioned.emit(self, "crouch")
		
	if direction == 0:
		animate(animation, direction)
