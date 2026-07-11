extends CharacterBody2D
class_name Fantasma

var can_hit_patinhas = true


func _ready() -> void:
	$CollisionShape2D.disabled = true
	velocity = Vector2.ZERO
	move_and_slide()
	
