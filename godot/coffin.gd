extends CharacterBody2D

var alreadyActive: bool = false

@export var spawnGhost: bool
@export var spawnItem: bool

@export var ghost_to_spawn: PackedScene
@export var item_to_spawn: PackedScene

func Active() -> void:
	if spawnGhost:		
		alreadyActive = true
		var obj = ghost_to_spawn.instantiate()
		var pos = Vector2(global_position.x, global_position.y - 20)
		obj.global_position = pos
		get_tree().current_scene.add_child(obj)
	if spawnItem:
		alreadyActive = true
		var obj = item_to_spawn.instantiate()
		var pos = Vector2(global_position.x, global_position.y - 20)
		obj.global_position = pos
		get_tree().current_scene.add_child(obj)
		obj.apply_tween()
