extends CharacterBody2D

var shake_tween: Tween

func _ready() -> void:
	start_shake()

func start_shake() -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	
	shake_tween = create_tween()
	var start_y = position.y
	
	shake_tween.tween_property(self, "position:y", start_y - 1, 0.1)
	shake_tween.tween_property(self, "position:y", start_y, 0.1)
	shake_tween.set_loops()
