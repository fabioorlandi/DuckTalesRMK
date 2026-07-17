extends CharacterBody2D
class_name Inimigo_Generico
signal die_on_collision

var player_on_screen := false
var direction := 1  
var collision_disabled := false
var can_hit_patinhas = true
var dying: bool = false

func is_pogo_interactive():
	return true

func _ready():
	connect("die_on_collision", _on_die)
	
	var inimigos = get_tree().get_nodes_in_group("Inimigos")
	for inimigo in inimigos:
		self.add_collision_exception_with(inimigo)
		
	var barreiras = get_tree().get_nodes_in_group("Barrier")
	for barreira in barreiras:
		self.add_collision_exception_with(barreira)
		
	var patinhas = get_tree().get_nodes_in_group("Patinhas")[0]
	self.add_collision_exception_with(patinhas)

func _on_die() -> void:
	if not dying:
		AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (28).wav"))
	
	dying = true
	
	$CollisionShape2D.set_deferred("disabled", true)
	collision_disabled = true
	$AnimatedSprite2D.pause()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - 15,
		0.2
	)
func _physics_process(delta: float) -> void:
	# gravidade sempre
	velocity.y += 200 * delta
	move_and_slide()
	if self.global_position.y >= 500:
		print("caíiii")
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	player_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	player_on_screen = false
