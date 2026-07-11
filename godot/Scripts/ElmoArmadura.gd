extends RigidBody2D
signal destroy_on_collision

var projectile = false
var can_be_destroyed = false

func is_pogo_interactive():
	return true

func _ready() -> void:
	destroy_on_collision.connect(destroy_body)

func destroy_body(direction: Vector2):
	if $"..".fallen and not $"..".is_falling:
		AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (11).wav"))
		
		if direction == Vector2.ZERO:
			$AnimatedSprite2D.play("destroy_helmet")
			await $AnimatedSprite2D.animation_finished
	
			$CollisionShapeElmoEstatico.disabled = true
			$CollisionShapeElmoCaido.disabled = true
			$CollisionShapeElmoEstatico.visible = false
			$CollisionShapeElmoEstatico.visible = false
			$AnimatedSprite2D.visible = false
		else:
			projectile = true
			freeze = false
			apply_impulse(Vector2(100, 250) * direction)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if $"..".fallen:
		$CollisionShapeElmoCaido.disabled = true
		$CollisionShapeElmoEstatico.disabled = true
		$AnimatedSprite2D.visible = false
