extends CharacterBody2D

enum Item { yellow_diamond_G, yellow_diamond_P, red_diamond_G, stage_trophy, skeleton_key, 
			cake, ice_cream, invulnerable, health_star, life_duck  }
			
@export var current_item: Item
@onready var ui = get_tree().get_first_node_in_group("ui")

@onready var fade = $Fade

var on_fade: bool = false
var collect_item_sfx = "res://Sounds/SFX/Duck Tales SFX (13).wav"

@onready var timer: Timer = $Timer
var timeLeft: int = 6

const y_force := -50.0

@export var destroyable: bool

@export var isStatic: bool = true
var direction: int = 1
@export var speed: float = 80.0
@export var gravity: float 
@export var max_fall_speed: float = 600.0

func _ready() -> void:
	var patinhas = get_tree().get_nodes_in_group("Patinhas")[0]
	self.add_collision_exception_with(patinhas)
	
	var fades = get_tree().get_nodes_in_group("Fade")
	if !fades.is_empty():
		fade = fades[0]
	
	$AnimatedSprite2D.play("brilho")
	
	if (destroyable):
		timer.timeout.connect(_on_timer_timeout)
		timer.start()
	
	gravity = 900.0
	if not isStatic:
		direction = _get_initial_direction()
	
	await get_tree().create_timer(.1).timeout
	$CollisionShape2D.disabled = false

func _on_timer_timeout():
	timeLeft -= 1
	
	if timeLeft <= 0:
		timer.stop()
		queue_free()
	elif timeLeft <= 3 and !on_fade:
		on_fade = true
		$AnimatedSprite2D.play("fade")

func _physics_process(delta: float) -> void:
	if isStatic == true:
		velocity.y += 400 * delta
		move_and_slide()
	else:
		if not is_on_floor():
			velocity.y += gravity * delta
			velocity.y = min(velocity.y, max_fall_speed)
		else:
			velocity.y = 0

		velocity.x = speed * direction

		move_and_slide()

		_check_wall_collision()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		DoFunction(body)
		
func apply_tween() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	velocity.y = 0
	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - 30,
		0.15
	)

func DoFunction(body: Node2D) -> void:
	AudioManager.play_sound_effect(load(collect_item_sfx))
	
	match current_item:
		Item.yellow_diamond_G:
			ui.AddScore(10000)
		Item.yellow_diamond_P:
			ui.AddScore(2000)
		Item.red_diamond_G:
			ui.AddScore(50000)
		Item.stage_trophy:
			AudioManager.play_background_music(load("res://Sounds/11_-_DuckTales_-_NES_-_Stage_Complete.ogg"))
			
			self.visible = false
			ui.AddScore(1000000)
			await get_tree().create_timer(1).timeout
			ui.AddToTotalScore()
			await get_tree().create_timer(2.5).timeout
			
			AudioManager.stop_background_music()
			
			await get_tree().create_timer(2).timeout
			
			fade.DoFadeOutToScene("res://main_menu.tscn")
		Item.invulnerable:
			body.emit_signal("invulnerability_ticks_started", 480, true)
		Item.health_star:
			ui.GainHealth()
		Item.life_duck:
			ui.GainLife()
		Item.cake:
			ui.ResetHealth()
		Item.ice_cream:
			ui.ReceiveCure(1)
	queue_free()

func _check_wall_collision() -> void:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		
		if abs(normal.x) > 0.5:
			direction *= -1
			break

func _get_initial_direction() -> int:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return -1

	if player.global_position.x < global_position.x:
		return -1 
	else:
		return 1 
