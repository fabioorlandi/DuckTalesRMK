extends State
class_name Ativado

@export var animation := &"Ativado"

var actor
var finished := false

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	actor.can_hit_patinhas = true
	
	finished = false
	$"../../CollisionShape2D".disabled = true
	$"../../IdleCollisionShape".disabled = false
	actor.position.y = actor.position.y - 1
	$"../../AnimatedSprite2D".play("Ativado")
	await $"../../AnimatedSprite2D".animation_finished
	actor.velocity.x = actor.direction * 50
	transitioned.emit(self, "move")

func update(_delta: float) -> void:
	if finished:
		return
	
		if actor.primeira_ativacao:
			actor.direction = -1
			actor.primeira_ativacao = false
		else:
			actor.direction *= -1



func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
