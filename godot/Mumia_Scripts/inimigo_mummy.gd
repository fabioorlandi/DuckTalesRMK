extends CharacterBody2D
class_name PatoMumia
signal die_on_collision

@export var direction := -1
var collision_disabled := false
var player_on_screen := false
var is_dead: bool = false
var can_hit_patinhas = true

func _ready():
	connect("die_on_collision", _on_die)
	var inimigos = get_tree().get_nodes_in_group("Inimigos")
	for inimigo in inimigos:
		self.add_collision_exception_with(inimigo)
	
	var barreiras = get_tree().get_nodes_in_group("Barrier")
	for barreira in barreiras:
		self.add_collision_exception_with(barreira)
	
	var bolas = get_tree().get_nodes_in_group("Bola")
	for bola in bolas:
		self.add_collision_exception_with(bola)
		
	var patinhas = get_tree().get_nodes_in_group("Patinhas")[0]
	self.add_collision_exception_with(patinhas)
	
func _on_die() -> void:
	if is_dead:
		return
	
	can_hit_patinhas = false
	
	is_dead = true 
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("Die_Mummy")
	await get_tree().create_timer(0.8).timeout
	$AnimatedSprite2D.play("Fall_Mummy")
	$CollisionShape2D.set_deferred("disabled", true)
	collision_disabled = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - 25,
		0.15
	)
	AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (28).wav"))

func _physics_process(delta):
	velocity.y += 200 * delta
	if self.global_position.y >= 500:
		print("caíiii")
		queue_free()
		return
	if is_dead:
		velocity.x = 0 
		move_and_slide() 
		return 

	move_and_slide()
	
	var area = self.get_node("ColisãoBola")
	for b in area.get_overlapping_bodies():
		if b.is_in_group("Bola") and b.projectile == true:
			emit_signal("die_on_collision")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	player_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	player_on_screen = false
