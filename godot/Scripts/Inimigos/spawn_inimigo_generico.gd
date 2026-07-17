extends Area2D

var enemy_scene = preload("res://Inimigos/inimigo_generico.tscn")
var current_enemy: Inimigo_Generico = null


	
func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_entered.connect(_on_screen_entered)
	
	
func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	current_enemy = enemy
	current_enemy.tree_exited.connect(_on_enemy_destroyed)
func _on_enemy_destroyed() -> void:
	# Clear the reference so the spawner knows it can spawn again
	current_enemy = null

func _on_screen_entered() -> void:
	if current_enemy == null:
		spawn_enemy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.
