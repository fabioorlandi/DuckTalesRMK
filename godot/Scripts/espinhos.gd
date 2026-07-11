extends Area2D
var isOnThorns: bool = false

func _physics_process(delta: float) -> void:
	if isOnThorns:
		var body = get_tree().get_nodes_in_group("Patinhas")[0]

		if not body.onPogo and body.invulnerability_ticks == 0:
			var currentState = body.get_node("FSM").current_state
			currentState.transitioned.emit(currentState, "damage")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		isOnThorns = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Patinhas":
		isOnThorns = false
