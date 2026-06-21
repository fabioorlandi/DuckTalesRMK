extends RigidBody2D
signal fall_on_collision

var can_fall = true
var fallen = false
var is_falling = false
var distance_ticks = 80;
var fall_direction = Vector2.ZERO

func _ready() -> void:
	$CharacterBodyElmo/CollisionShapeElmoCaido.disabled = true
	fall_on_collision.connect(fall_body)

func _physics_process(delta: float) -> void:
	if not fallen or not can_fall:
		return
		
	distance_ticks -= 1;
	
	if not is_falling:
		is_falling = true
		$CharacterBodyElmo/CollisionShapeElmoEstatico.disabled = true
		$CharacterBodyElmo/CollisionShapeElmoCaido.disabled = false
	
		$CharacterBodyElmo/AnimatedSprite2D.global_rotation_degrees = -90
		$CharacterBodyElmo/CollisionShapeElmoCaido.global_rotation_degrees = -90
		
		var tween_shake = create_tween()
		var start_x = $CharacterBodyElmo.position.x
	
		var shake_intensity = 2
		for i in range(16):
			var offset_x = randf_range(-shake_intensity, shake_intensity)
			tween_shake.tween_property($CharacterBodyElmo, "position:x", start_x + offset_x, 0.05)
	
		tween_shake.tween_property($CharacterBodyElmo, "position:x", start_x, 0.05)
	
		await tween_shake.finished
	
	$CharacterBodyElmo.velocity = fall_direction * Vector2(-5, 8) * 20
	$CharacterBodyElmo.add_collision_exception_with(get_parent().get_parent().get_node("Patinhas"))
	$CharacterBodyElmo.move_and_slide()
	
	if distance_ticks <= 0:
		can_fall = false
		is_falling = false
		$CharacterBodyElmo.can_be_destroyed = true
		$CharacterBodyElmo.remove_collision_exception_with(get_parent().get_parent().get_node("Patinhas"))

func fall_body(direction: Vector2):
	fallen = true
	fall_direction = direction
