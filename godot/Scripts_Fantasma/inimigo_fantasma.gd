extends CharacterBody2D




func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	velocity = Vector2.ZERO
	move_and_slide()
