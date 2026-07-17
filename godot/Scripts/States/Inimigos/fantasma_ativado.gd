extends State

@export var speed_y := 150.0

var actor
var direction
var player
var alvo_y := 0.0

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	await get_tree().create_timer(0.8).timeout
	$"../../AnimatedSprite2D".visible = true
	
	AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (29).wav"))
	
	player = get_tree().get_first_node_in_group("Patinhas")
	
	if player == null:
		return
	
	$"../../AnimatedSprite2D".flip_h = player.global_position.x > actor.global_position.x
	
	alvo_y = player.global_position.y - 10

func physics_update(_delta: float) -> void:
	if player == null:
		return
	
	actor.velocity = Vector2(0, speed_y)
	actor.move_and_slide()

	if actor.global_position.y >= alvo_y:
		actor.velocity = Vector2.ZERO
		transitioned.emit(self, "movendo")
