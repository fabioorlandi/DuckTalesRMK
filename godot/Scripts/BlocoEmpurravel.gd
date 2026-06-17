extends RigidBody2D
signal slide_on_collision

func _ready() -> void:
	slide_on_collision.connect(slide_body)

func _process(delta: float) -> void:
	pass

func slide_body():
	pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass
