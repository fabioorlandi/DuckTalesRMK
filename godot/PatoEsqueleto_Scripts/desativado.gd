extends State
class_name Desativado

@export var animation := &"Desativado"

var actor
var finished := false

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	finished = false
	
	# PARA o movimento
	actor.velocity = Vector2.ZERO
	
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.play(animation)

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

func _physics_update(_delta: float) -> void:
	actor.velocity.y += 1000 * _delta
	actor.velocity.x = 0
	actor.move_and_slide()

func exit() -> void:
	pass
