extends Area2D

@export var canTravel: bool

@export var positionTo: Vector2
@export var floorPos : float
@export var screenLayer: int

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas" and canTravel:
		AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (30).wav"))
		
		$"../../Fade".DoFadeInOutTeleport(positionTo, floorPos, screenLayer)
