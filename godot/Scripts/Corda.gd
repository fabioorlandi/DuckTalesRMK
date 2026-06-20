extends Area2D
var soucorda: bool

@export var ropeX: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		body.SetClimb(true, ropeX)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Patinhas":
		body.SetClimb(false, ropeX)
