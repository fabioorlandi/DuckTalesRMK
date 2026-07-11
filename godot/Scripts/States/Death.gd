extends State
class_name Death

@export var player: CharacterBody2D

func enter() -> void:
	player.emit_signal("patinhas_death")
