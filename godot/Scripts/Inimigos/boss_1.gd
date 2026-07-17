extends CharacterBody2D
class_name Boss1
signal die_on_collision


var player_on_screen := false
var can_hit_patinhas = true
var actor
var direction := 1  
var collision_disabled := false
var vidas: int
var morrendo : bool = false
var invulnerability_ticks = 0

@export var itemSpawner: PackedScene
@export var trophy: PackedScene

func _ready():
	connect("die_on_collision", _on_die)
	var inimigos = get_tree().get_nodes_in_group("Inimigos")
	for inimigo in inimigos:
		self.add_collision_exception_with(inimigo)
		
	var patinhas = get_tree().get_nodes_in_group("Patinhas")[0]
	self.add_collision_exception_with(patinhas)
	
	vidas = 3
	var player = get_tree().get_first_node_in_group("Patinhas")
	if player:
		player.patinhas_death.connect(_on_player_death)
		
func _on_player_death():
	await get_tree().create_timer(5.0).timeout
	queue_free()
	print("despawnei")

func _on_die():
	if invulnerability_ticks > 0:
		return
	
	can_hit_patinhas = false
	if vidas >= 1:
		invulnerability_ticks = 100
		vidas -= 1
		if vidas > 0:
			modulate_boss()
	else:
		pass
		
	if vidas == 0:
		morrendo = true
		
		AudioManager.play_sound_effect(load("res://Sounds/SFX/Duck Tales SFX (28).wav"))
		
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.pause()
		
		velocity = Vector2.ZERO
		
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", global_position.y - 25, 0.15)

func _physics_process(delta: float) -> void:
	if invulnerability_ticks > 0:
		invulnerability_ticks -= 1
	
	if morrendo:
		can_hit_patinhas = false

		velocity.y += 800 * delta
		
		move_and_slide()
		
		if global_position.y > 700:
			print("Boss Morreu") 
			AudioManager.process_mode = Node.PROCESS_MODE_ALWAYS

			get_tree().paused = true
			await get_tree().create_timer(1).timeout
			var obj = itemSpawner.instantiate()
			obj.global_position = Vector2(1408.0, -344.0 )
			obj.SetChest()
			obj.canIPogoAndAttack = true
			obj.item_to_spawn = trophy
			get_tree().current_scene.add_child(obj)
			await get_tree().create_timer(1).timeout
			get_tree().paused = false
			
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
