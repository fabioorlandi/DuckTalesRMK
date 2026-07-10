extends State

@export var speed_y := 80.0

var actor
var player
var alvo_y := 0.0

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	if player == null:
		return
	
	alvo_y = player.global_position.y

func physics_update(delta: float) -> void:
	if player == null:
		return

	actor.velocity = Vector2(0, speed_y)
	actor.move_and_slide()

	if actor.global_position.y >= alvo_y:
		actor.velocity = Vector2.ZERO
		transitioned.emit(self, "movendo")
