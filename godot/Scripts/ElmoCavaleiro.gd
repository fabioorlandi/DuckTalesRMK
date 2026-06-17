extends RigidBody2D
signal fall_on_collision

var fallen = false
var is_falling = false

func _ready() -> void:
	$CollisionShapeElmoCaido.disabled = true
	fall_on_collision.connect(fall_body)

func _process(delta: float) -> void:
	pass

func fall_body():
	if fallen or is_falling:
		return
		
	is_falling = true
	$CollisionShapeElmoEstatico.disabled = true
	$CollisionShapeElmoCaido.disabled = false
	
	$Sprite2D.global_rotation_degrees = -90
	$CollisionShapeElmoCaido.global_rotation_degrees = -90
	
	var tween = create_tween()
	var start_x = position.x
	
	var shake_intensity = 2
	for i in range(24):
		var offset_x = randf_range(-shake_intensity, shake_intensity)
		tween.tween_property(self, "position:x", start_x + offset_x, 0.05)
	
	tween.tween_property(self, "position:x", start_x, 0.05)
	
	await tween.finished
	
	apply_impulse(Vector2(-100, -200))

	is_falling = false
	fallen = true
