extends CharacterBody2D
class_name PatoEsqueleto

var primeira_ativacao := true
var player_on_screen := false

var direction := -1  # começa indo pra esquerda

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	player_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	player_on_screen = false
