extends CharacterBody2D
class_name BolaMumia
signal die_on_collision

func _ready():
	connect("die_on_collision", _on_die)
	add_to_group("bola")
	var inimigos = get_tree().get_nodes_in_group("Inimigos")
	for inimigo in inimigos:
		self.add_collision_exception_with(inimigo)
		
	#var patinhas = get_tree().get_nodes_in_group("Patinhas")[0]
	#self.add_collision_exception_with(patinhas)
func _on_die() -> void:
	$"Ball Sprite".play("Explosão")
	await $"Ball Sprite".animation_finished
	queue_free()
