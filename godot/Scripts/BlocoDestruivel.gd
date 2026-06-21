extends RigidBody2D
signal destroy_on_collision

var can_be_destroyed = true
var projectile = false

func _ready() -> void:
	freeze = true
	destroy_on_collision.connect(destroy_body)

func _physics_process(delta: float) -> void:
	pass

func destroy_body(direction: Vector2):
	var areas = $DetectSorroundingObjects.get_overlapping_areas().filter(\
		func(area): return area.get_parent() is RigidBody2D and area.monitoring and area.monitorable)
	
	if areas.size() >= 1:
		$AnimatedSprite2D.play("destroy_block")
		await $AnimatedSprite2D.animation_finished
		
		$DetectSorroundingObjects/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		$CollisionShape2D.visible = false
		$AnimatedSprite2D.visible = false
	else:
		freeze = false
		projectile = true
		$AnimatedSprite2D.play("destroy_block_projectile")
		apply_impulse(Vector2(100, 250) * direction)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$AnimatedSprite2D.play("block")
	
	$DetectSorroundingObjects/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
	$CollisionShape2D.visible = true
	$AnimatedSprite2D.visible = true

func _on_detect_sorrounding_objects_body_entered(body: Node2D) -> void:
	if not projectile:
		return
		
	$AnimatedSprite2D.play("destroy_block")
	await $AnimatedSprite2D.animation_finished
	
	freeze = true
	projectile = false
	
	$DetectSorroundingObjects/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$CollisionShape2D.visible = false
	$AnimatedSprite2D.visible = false
