extends State

@export var speed_x := 60.0
@export var speed_y := 80.0

var actor

var fase := 0
var tempo := 0.0

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	
	fase = 0
	tempo = 0.0

func physics_update(delta: float) -> void:
	tempo += delta

	match fase:

		# ⬅️ esquerda
		0:
			actor.velocity = Vector2(-speed_x, 0)
			actor.velocity.y = randf_range(-130, 130)
			if tempo >= 0.3:
				trocar_fase(1)

		# ⬆️ sobe
		1:
			actor.velocity = Vector2(0, -speed_y)
			if tempo >= 0.3:
				trocar_fase(2)

		# ⬅️ esquerda
		2:
			actor.velocity = Vector2(-speed_x, 0)
			actor.velocity.y = randf_range(-130, 130)
			if tempo >= 0.6:
				trocar_fase(3)

		# ⬇️ desce
		3:
			actor.velocity = Vector2(0, speed_y)
			if tempo >= 0.3:
				trocar_fase(0)

	actor.move_and_slide()

func trocar_fase(nova):
	fase = nova
	tempo = 0.0
