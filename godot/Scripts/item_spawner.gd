extends Area2D

@export var item_to_spawn: PackedScene

var already_obtained: bool = false
@export var isChest: bool

func _ready() -> void:
	if isChest:
		$CharacterBody2D.visible = true
		$CharacterBody2D/CollisionShape2D.disabled = false
	else:		
		$CharacterBody2D.visible = false
		$CharacterBody2D/CollisionShape2D.disabled = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas" and !already_obtained:
		already_obtained = true
		await get_tree().create_timer(.5).timeout
		$AnimatedSprite2D.play("explode")
		await get_tree().create_timer(.2).timeout
		$AnimatedSprite2D.play("empty")
		var obj = item_to_spawn.instantiate()
		obj.global_position = global_position
		get_tree().current_scene.add_child(obj)
		obj.apply_tween()

func active_from_chest() -> void:
		already_obtained = true
		var obj = item_to_spawn.instantiate()
		obj.global_position = global_position
		get_tree().current_scene.add_child(obj)
		obj.apply_tween()
