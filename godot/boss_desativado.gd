extends State
class_name BossDesativado
var actor

func enter():
	actor = get_parent().get_parent()
	
func update(delta: float) -> void:
	if actor.morrendo:
		return
	if actor.player_on_screen:
		transitioned.emit(self, "decolando")
func _physics_process(delta: float) -> void:
	if actor.morrendo:
		return
