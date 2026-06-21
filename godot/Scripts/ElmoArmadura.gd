extends CharacterBody2D
signal destroy_on_collision

var can_be_destroyed = false

func _ready() -> void:
	destroy_on_collision.connect(destroy_body)

func destroy_body(direction: Vector2):
	if $"..".fallen and not $"..".is_falling:
		if direction == Vector2.ZERO:
			$AnimatedSprite2D.play("destroy_helmet")
			await $AnimatedSprite2D.animation_finished
	
			$CollisionShapeElmoEstatico.disabled = true
			$CollisionShapeElmoCaido.disabled = true
			$CollisionShapeElmoEstatico.visible = false
			$CollisionShapeElmoEstatico.visible = false
			$AnimatedSprite2D.visible = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if $"..".fallen:
		$CollisionShapeElmoCaido.disabled = true
		$CollisionShapeElmoEstatico.disabled = true
		$AnimatedSprite2D.visible = false
