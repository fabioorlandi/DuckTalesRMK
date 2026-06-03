extends Node
class_name State

signal transitioned

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
	
func _physics_update(delta: float) -> void:
	pass

func animate(animation: String, flip_h: bool = false):
	var animated_sprite = self.get_parent().get_parent()\
		.get_node("AnimatedSprite2D")
	animated_sprite.animation = animation
	animated_sprite.flip_h  = flip_h
	animated_sprite.play()
