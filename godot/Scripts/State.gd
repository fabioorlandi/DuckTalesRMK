extends Node
class_name State

signal transitioned

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func animate(animation: String, direction: float):
	var animated_sprite = self.get_parent().get_parent()\
		.get_node("AnimatedSprite2D")
	animated_sprite.animation = animation
	
	if direction != 0:
		animated_sprite.flip_h = direction < 0
	
	animated_sprite.play()
