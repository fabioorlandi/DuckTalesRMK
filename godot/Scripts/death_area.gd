extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Patinhas"):
		body.emit_signal("on_death_area")

	if body.has_signal("free_on_death_area"):
		body.emit_signal("free_on_death_area")
