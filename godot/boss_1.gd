extends CharacterBody2D
signal die_on_collision

var player_on_screen := false
var can_hit_patinhas = true
var actor
var direction := 1  
var collision_disabled := false
var vidas: int
var morrendo : bool = false

func _ready():
	connect("die_on_collision", _on_die)
	var inimigos = get_tree().get_nodes_in_group("Inimigos")
	for inimigo in inimigos:
		self.add_collision_exception_with(inimigo)
		
	var patinhas = get_tree().get_nodes_in_group("Patinhas")[0]
	self.add_collision_exception_with(patinhas)
	
	vidas = 3

func _on_die():
	if vidas >= 1:
		vidas -= 1
		if vidas > 0:
			modulate_boss()
	else:
		pass
		
	if vidas == 0:
		morrendo = true
		
		
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.pause()
		
		velocity = Vector2.ZERO
		
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", global_position.y - 25, 0.15)

	
		
func _physics_process(delta: float) -> void:
	if morrendo:
		# gravidade
		velocity.y += 800 * delta
		
		move_and_slide()
		
		# saiu da tela (ou passou de um limite)
		if global_position.y > 700:
			print("MORREU E SAIU")
			queue_free()
		
		return
		
	
func modulate_boss():
	
	var tween = create_tween()
	for i in range(24):
		tween.tween_callback(func(): modulate.a = 0)
		tween.tween_interval(0.02)
		tween.tween_callback(func(): modulate.a = 1)
		tween.tween_interval(0.02)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	player_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	player_on_screen = false
