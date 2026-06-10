extends State
class_name IDLE

@export var animation = &"idle"
@export var reactivate_delay := 1.0
var actor
var timer := 0.0

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	timer = 0.0
	
	actor.velocity = Vector2.ZERO
	
	var anim = actor.get_node("AnimatedSprite2D")
	anim.play(animation)

func update(delta: float) -> void:
	timer += delta
	
	if actor.player_on_screen and timer >= reactivate_delay:
		transitioned.emit(self, "ativado")

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
