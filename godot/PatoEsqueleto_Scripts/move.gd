extends State
class_name InimigoMove

@export var speed := 50.0

var actor

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.play("Caminhar")

func physics_update(_delta: float) -> void:
	# movimento horizontal
	actor.velocity.x = actor.direction * speed
	
	# gravidade (pra cair depois)
	actor.velocity.y += 800
	
	actor.move_and_slide()
	
	# flip
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.flip_h = actor.direction > 0
	
	# colisão → sobe e troca estado
	if actor.is_on_wall():
		var collision = actor.get_last_slide_collision()
		if collision:
			var body = collision.get_collider()
			body.emit_signal("destroy_on_collision", Vector2.ZERO)
		
		transitioned.emit(self, "desativado")
