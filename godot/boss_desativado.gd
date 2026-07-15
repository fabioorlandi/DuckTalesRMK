extends State
class_name BossDesativado
var actor

func enter():
	actor = get_parent().get_parent()
	
func update(delta: float) -> void:
	
		if actor.player_on_screen:
			transitioned.emit(self, "decolando")
