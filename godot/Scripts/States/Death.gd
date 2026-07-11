extends State
class_name Death

@export var player: CharacterBody2D
@export var animation = &"Morte"
var dying = true
 
func enter() -> void:
	player.onRope = false
	dying = true

	player.emit_signal("on_die")
	await get_tree().create_timer(0.18).timeout
	
	dying = false

func exit() -> void:
	player.collisionWithEnemy = false

func update(_delta: float) -> void:
	pass
 
func physics_update(delta: float) -> void:
	if dying:
		return

	player.velocity.y += player.GRAVITY * delta #Gravidade aplicada
 
