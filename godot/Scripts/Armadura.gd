extends RigidBody2D
signal fall_on_collision

var can_fall = true
var fallen = false
var is_falling = false
var distance_ticks = 80;
var fall_direction = Vector2.ZERO

func _ready() -> void:
	$RigidBodyElmo/CollisionShapeElmoCaido.disabled = true
	fall_on_collision.connect(fall_body)

func _physics_process(delta: float) -> void:
	if not fallen or not can_fall:
		return
		
	if not is_falling:
		is_falling = true
		$RigidBodyElmo/CollisionShapeElmoEstatico.disabled = true
		$RigidBodyElmo/CollisionShapeElmoCaido.disabled = false
	
		$RigidBodyElmo/AnimatedSprite2D.global_rotation_degrees = -90
		$RigidBodyElmo/CollisionShapeElmoCaido.global_rotation_degrees = -90
		
		var tween_shake = create_tween()
		var start_x = $RigidBodyElmo.position.x
	
		var shake_intensity = 2
		for i in range(16):
			var offset_x = randf_range(-shake_intensity, shake_intensity)
			tween_shake.tween_property($RigidBodyElmo, "position:x", start_x + offset_x, 0.05)
	
		tween_shake.tween_property($RigidBodyElmo, "position:x", start_x, 0.05)
	
		await tween_shake.finished
	
		$RigidBodyElmo.add_to_group("Inimigos")
		$RigidBodyElmo.apply_impulse(Vector2(-100, -200) * fall_direction)

	if is_falling:
		distance_ticks -= 1

	if distance_ticks <= 0:
		can_fall = false
		is_falling = false
		$RigidBodyElmo.remove_from_group("Inimigos")

func fall_body(direction: Vector2):
	fallen = true
	fall_direction = direction

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_falling and body.name == "Patinhas":
		body.emit_signal("take_damage")
		await get_tree().create_timer(0.18).timeout
	
	if can_fall or body.name == "Patinhas":
		return
	
	if not $RigidBodyElmo.projectile:
		$RigidBodyElmo.freeze = true
		$RigidBodyElmo.can_be_destroyed = true
	else:
		$RigidBodyElmo/AnimatedSprite2D.play("destroy_helmet")
		await $RigidBodyElmo/AnimatedSprite2D.animation_finished
	
		$RigidBodyElmo/CollisionShapeElmoEstatico.disabled = true
		$RigidBodyElmo/CollisionShapeElmoCaido.disabled = true
		$RigidBodyElmo/CollisionShapeElmoEstatico.visible = false
		$RigidBodyElmo/CollisionShapeElmoEstatico.visible = false
		$RigidBodyElmo/AnimatedSprite2D.visible = false
