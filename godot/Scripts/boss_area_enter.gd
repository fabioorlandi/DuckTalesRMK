extends Area2D

var boss_music_started = false

@onready var blockArena

func _ready() -> void:
	var blocks = get_tree().get_nodes_in_group("ArenaBlock")
	if !blocks.is_empty():
		blockArena = blocks[0]

func tocar_musica_boss():
	var boss_music = load("res://Sounds/10_-_DuckTales_-_NES_-_Boss_Battle.ogg")
	AudioManager.play_background_music(boss_music)

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Patinhas") and not boss_music_started:
		blockArena.disabled = false
		$"../../Camera2D".TransitionBossSite()
		boss_music_started = true
		tocar_musica_boss()
		print("entrou")
