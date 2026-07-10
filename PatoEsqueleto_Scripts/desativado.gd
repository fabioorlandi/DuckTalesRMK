extends State
class_name Desativado

@export var animation := &"Desativado"

var actor
var finished := false

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	$"../../CollisionShape2D".disabled = true
	$"../../IdleCollisionShape".disabled = false
	finished = false
	# PARA o movimento
	actor.velocity = Vector2.ZERO
	
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.play(animation)
	var tween = create_tween()

	tween.tween_property(actor, "position:y", actor.position.y - 15, 0.15)
	tween.tween_property(actor, "position:y", actor.position.y, 0.25)

	await tween.finished
func update(_delta: float) -> void:
	if finished:
		return
	
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	
	# quando chegar no último frame
	if sprite.frame == sprite.sprite_frames.get_frame_count(animation) - 1:
		finished = true
		actor.direction *= -1
		# volta pro idle (desmontado)
		transitioned.emit(self, "idle")

func physics_update(_delta: float) -> void:
	
	actor.velocity.x = 0
	actor.move_and_slide()

func exit() -> void:
	pass
