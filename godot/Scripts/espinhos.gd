extends Area2D
var isOnThorns: bool = false

func _process(delta: float) -> void:
	if isOnThorns:
		var body = get_tree().get_nodes_in_group("Patinhas")[0]

		var currentState = body.get_node("FSM").current_state
		currentState.transitioned.emit(currentState, "damage")

func _on_body_entered(body: Node2D) -> void:
	if not isOnThorns\
		and body.name == "Patinhas"\
		and body.invulnerability_ticks == 0\
		and not body.onPogo:
		isOnThorns = true
		var currentState = body.get_node("FSM").current_state
		currentState.transitioned.emit(currentState, "damage")


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Patinhas" and not body.onPogo:
		isOnThorns = false
