extends RigidBody2D
signal destroy_on_collision

func _ready() -> void:
	$AnimatedSprite2D.play("block")
	destroy_on_collision.connect(destroy_body)

func _process(delta: float) -> void:
	pass

func destroy_body():
	$AnimatedSprite2D.play("destroy_block")
	await $AnimatedSprite2D.animation_finished
	
	queue_free()
