extends CharacterBody2D
signal die_on_collision

@export var direction := -1
var collision_disabled := false
var player_on_screen := false
var is_dead: bool = false

func _ready():
	connect("die_on_collision", _on_die)

func _on_die() -> void:
	if is_dead: return 
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


func _physics_process(delta):
	velocity.y += 200 * delta
	if self.global_position.y >= 1110:
		print("caíiii")
		queue_free()
		return
	if is_dead:
		velocity.x = 0 
		move_and_slide() 
		return 
	
	
	move_and_slide()



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	player_on_screen = true
	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	player_on_screen = false
	
	
	
