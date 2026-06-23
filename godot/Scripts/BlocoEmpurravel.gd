extends CharacterBody2D
signal slide_on_collision(direction: float)

var can_slide = true
var is_sliding = false
var slide_direction = Vector2.ZERO

func _ready() -> void:
	slide_on_collision.connect(slide_body)

func _process(delta: float) -> void:
	if is_sliding and is_on_floor():
		can_slide = false
		velocity = slide_direction * Vector2(10, 0) * 20
		
		var collision = self.get_last_slide_collision()
		if collision:
			var body = collision.get_collider()
			if body and body.has_signal("die_on_collision"):
				body.emit_signal("die_on_collision")
	else:
		velocity.x = 0
		velocity.y += 5
		is_sliding = false
		can_slide = true

	move_and_slide()

func slide_body(direction: Vector2):
	is_sliding = true
	slide_direction = direction

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
