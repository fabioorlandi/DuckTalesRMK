extends State
class_name Pousando

var actor

func _ready():
	actor = get_parent().get_parent()

func enter():
	actor.velocity = Vector2(0, 150)
func _physics_process(delta: float) -> void:
	if actor.morrendo:
		return
func physics_update(delta):
	if actor.morrendo:
		return
	actor.move_and_slide()
	
	if actor.is_on_floor():
		actor.velocity = Vector2.ZERO
		transitioned.emit(self, "atirando")
