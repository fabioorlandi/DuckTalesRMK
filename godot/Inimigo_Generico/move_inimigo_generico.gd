extends State
class_name Inimigo2Move

@export var speed := 30.0
var is_turning = false
var actor

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.play("Inimigo_generico_caminhar")

func physics_update(_delta: float) -> void:
	
	
	actor.velocity.x = actor.direction * speed
	actor.move_and_slide()
	
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.flip_h = actor.direction < 0
	if actor.is_on_wall() and not is_turning:
		is_turning = true
		await get_tree().create_timer(2).timeout
		actor.direction *= -1
		is_turning = false
		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.transitioned.emit(self, "desativado")
