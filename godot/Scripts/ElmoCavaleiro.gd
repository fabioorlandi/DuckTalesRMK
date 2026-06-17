extends RigidBody2D
signal fall_on_collision

var fallen = false

func _ready() -> void:
	self.gravity_scale = 0
	$CollisionShapeElmoCaido.disabled = true
	fall_on_collision.connect(fall_body)

func _process(delta: float) -> void:
	pass

func fall_body():
	if fallen:
		return
	
	$CollisionShapeElmoEstatico.disabled = true
	$CollisionShapeElmoCaido.disabled = false
	
	self.gravity_scale = 1

	$Sprite2D.global_rotation_degrees = -90
	$CollisionShapeElmoCaido.global_rotation_degrees = -90
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", 
		self.position.x - 50, 2)\
	.set_trans(Tween.TRANS_ELASTIC)\
	.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	fallen = true
