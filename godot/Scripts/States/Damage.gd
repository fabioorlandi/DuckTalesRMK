extends State
class_name Damage

@export var player: CharacterBody2D
@export var animation = &"Dano"
var takingDamage = true
 
func enter() -> void:
	player.onRope = false
	takingDamage = true

	player.emit_signal("take_damage")
	await get_tree().create_timer(0.18).timeout
	
	takingDamage = false

func exit() -> void:
	player.collisionWithEnemy = false

func update(_delta: float) -> void:
	pass
 
func physics_update(delta: float) -> void:
	if takingDamage:
		return

	if not player.is_on_floor():
		transitioned.emit(self, "fall")
	else:
		transitioned.emit(self, "idle")
		
	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
 
	player.move_and_slide()
