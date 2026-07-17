extends State

var actor

func _ready():
	$"../../AnimatedSprite2D".visible = false
	actor = get_parent().get_parent()

func enter():
	var notifier = actor.get_node("VisibleOnScreenNotifier2D")
	
	if notifier.is_on_screen():
		transitioned.emit(self, "ativado")
		
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	transitioned.emit(self, "ativado")
