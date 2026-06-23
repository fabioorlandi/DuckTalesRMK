extends State
class_name InimigoMove

@export var speed := 50.0

var actor

func _ready():
	actor = get_parent().get_parent()
	
func enter() -> void:
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.play("Caminhar")
	$"../../CollisionShape2D".disabled = false
	$"../../IdleCollisionShape".disabled = true
func physics_update(_delta: float) -> void:
	# movimento horizontal
	if actor.collision_disabled:
		actor.velocity.x = 0
	else:
		actor.velocity.x = actor.direction * speed
	
	actor.move_and_slide()
	
	# flip
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.flip_h = actor.direction > 0
	
	if actor.is_on_wall():
		var collision = actor.get_last_slide_collision()
		if collision:
			var body = collision.get_collider()
			if body and body.has_signal("destroy_on_collision"):
				body.emit_signal("destroy_on_collision", Vector2.ZERO)
		
		transitioned.emit(self, "desativado")
