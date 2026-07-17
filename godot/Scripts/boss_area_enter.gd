extends Area2D

var boss_music_started = false

func tocar_musica_boss():
	var boss_music = load("res://Sounds/10_-_DuckTales_-_NES_-_Boss_Battle.ogg")
	AudioManager.play_background_music(boss_music)

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Patinhas") and not boss_music_started:
		var barriers = get_tree().get_nodes_in_group("Barrier")
		for barrier in barriers:
			if barrier.name == "BossInvisibleBarrier":
				var collisionShape = barrier.get_node("CollisionShape2D")
				collisionShape.set_deferred("disabled", false)
		
		$"../../Camera2D".TransitionInBossSite()
		boss_music_started = true
		tocar_musica_boss()
		print("entrou")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Patinhas") and body.dead:
		var barriers = get_tree().get_nodes_in_group("Barrier")
		for barrier in barriers:
			if barrier.name == "BossInvisibleBarrier":
				var collisionShape = barrier.get_node("CollisionShape2D")
				collisionShape.set_deferred("disabled", true)
		
		$"../../Camera2D".TransitionOutBossSite()
		boss_music_started = false
		print("morreu")
