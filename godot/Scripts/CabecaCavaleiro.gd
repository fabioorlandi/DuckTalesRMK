extends RigidBody2D
signal fall_on_collision

func _ready() -> void:
	self.gravity_scale = 0
	$CollisionShape2DCaido.disabled = true
	fall_on_collision.connect(fall_body)

func _process(delta: float) -> void:
	pass

func fall_body():
	$Sprite2D.global_rotation_degrees = -90
	$CollisionShape2DEstatico.disabled = true
	$CollisionShape2DCaido.disabled = false
