extends State
class_name Pousando

var actor

func _ready():
	actor = get_parent().get_parent()

func enter():
	actor.velocity = Vector2(0, 100)

func physics_update(delta):
	actor.move_and_slide()
	
	if actor.is_on_floor():
		actor.velocity = Vector2.ZERO
		transitioned.emit(self, "atirando")
