extends Area2D
var isOnThorns: bool = false

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas" and not body.onPogo:
		isOnThorns = true
		body.emit_signal("take_damage")


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Patinhas" and not body.onPogo:
		isOnThorns = false
