extends CharacterBody2D
class_name PatoEsqueleto
signal die_on_collision

var collision_disabled := false
var primeira_ativacao := true
var player_on_screen := false

var direction := -1  

func _ready():
	connect("die_on_collision", _on_die)

func _on_die() -> void:
	if $FSM.current_state is IDLE:
		return

	$CollisionShape2D.set_deferred("disabled", true)
	$IdleCollisionShape.set_deferred("disabled", true)
	collision_disabled = true
	$AnimatedSprite2D.pause()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - 25,
		0.15
	)
func _physics_process(delta: float) -> void:
	velocity.y += 200 * delta
	
	if self.global_position.y >= 1110:
		print("caíiii")
		queue_free()
	
	move_and_slide()
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	player_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	player_on_screen = false
	
