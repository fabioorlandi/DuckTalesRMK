extends State
class_name Ativado

@export var animation := &"Ativado"

var actor
var finished := false

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	finished = false
	$"../../CollisionShape2D".disabled = true
	$"../../IdleCollisionShape".disabled = false
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.play(animation)

func update(_delta: float) -> void:
	if finished:
		return
	
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	
	if sprite.frame == sprite.sprite_frames.get_frame_count(animation) - 1:
		finished = true
		
		if actor.primeira_ativacao:
			actor.direction = -1
			actor.primeira_ativacao = false
		else:
			actor.direction *= -1

	actor.velocity.x = actor.direction * 50
	transitioned.emit(self, "move")

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
