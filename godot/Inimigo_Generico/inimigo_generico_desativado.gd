extends Node



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	transitioned.emit(self,"move")
