extends Area2D

@export var canTravel: bool

@export var positionTo: Vector2
@export var floorPos : float

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas" and canTravel:
		body.Teleport(positionTo, floorPos)
