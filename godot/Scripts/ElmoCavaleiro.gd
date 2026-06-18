extends CharacterBody2D
signal fall_on_collision

var can_fall = true
var fallen = false
var is_falling = false
var distance_ticks = 80;

func _ready() -> void:
	$CollisionShapeElmoCaido.disabled = true
	fall_on_collision.connect(fall_body)

func _physics_process(delta: float) -> void:
	if not fallen or not can_fall:
		return
		
	distance_ticks -= 1;
	
	if not is_falling:
		is_falling = true
		$CollisionShapeElmoEstatico.disabled = true
		$CollisionShapeElmoCaido.disabled = false
	
		$Sprite2D.global_rotation_degrees = -90
		$CollisionShapeElmoCaido.global_rotation_degrees = -90
		
		var tween_shake = create_tween()
		var start_x = position.x
	
		var shake_intensity = 2
		for i in range(16):
			var offset_x = randf_range(-shake_intensity, shake_intensity)
			tween_shake.tween_property(self, "position:x", start_x + offset_x, 0.05)
	
		tween_shake.tween_property(self, "position:x", start_x, 0.05)
	
		await tween_shake.finished
	
	velocity = Vector2(-5, 8) * 20
	if distance_ticks <= 0:
		can_fall = false
		is_falling = false

	move_and_slide()

func fall_body():
	fallen = true
