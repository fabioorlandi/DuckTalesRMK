extends RigidBody2D
signal destroy_on_collision

func _ready() -> void:
	destroy_on_collision.connect(destroy_body)

func _process(delta: float) -> void:
	pass

func destroy_body():
	$AnimatedSprite2D.play("destroy_block")
	await $AnimatedSprite2D.animation_finished
	
	#$CollisionShape2D.disabled = true
	$CollisionShape2D.visible = false
	$AnimatedSprite2D.visible = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$AnimatedSprite2D.play("block")
	
	#$CollisionShape2D.disabled = false
	$CollisionShape2D.visible = true
	$AnimatedSprite2D.visible = true
