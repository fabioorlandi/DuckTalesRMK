extends CharacterBody2D
signal slide_on_collision

var can_slide = false

func _ready() -> void:
	slide_on_collision.connect(slide_body)

func _physics_process(delta: float) -> void:
	if can_slide and is_on_floor() and not is_on_wall():
		velocity = Vector2(10, 0) * 20
	else:
		velocity.x = 0
		velocity.y += 5
		can_slide = false

	move_and_slide()

func slide_body():
	can_slide = true

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass
