extends CharacterBody2D
class_name Inimigo_Generico
signal die_on_collision

var player_on_screen := false
var direction := 1  
var collision_disabled := false
func _ready():
	connect("die_on_collision", _on_die)

func _on_die() -> void:

	$CollisionShape2D.set_deferred("disabled", true)
	collision_disabled = true
	$AnimatedSprite2D.pause()
	velocity.x = 0
	
func _physics_process(delta: float) -> void:
	# gravidade sempre
	velocity.y += 200 * delta
	move_and_slide()
	if self.global_position.y >= 1110:
		print("caíiii")
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	player_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	player_on_screen = false
