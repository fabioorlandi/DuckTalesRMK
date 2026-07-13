extends CharacterBody2D

enum Item { yellow_diamond_G, yellow_diamond_P, red_diamond_G, stage_trophy, skeleton_key, 
			cake, ice_cream, invulnerable, health_star, life_duck  }
			
@export var current_item: Item
@onready var ui = get_tree().get_first_node_in_group("ui")

var on_fade: bool = false
var collect_item_sfx = "res://Sounds/SFX/Duck Tales SFX (13).wav"

@onready var timer: Timer = $Timer
var timeLeft: int = 6

const gravity = -400.0
const y_force := -50.0

@export var destroyable: bool

func _ready() -> void:
	$AnimatedSprite2D.play("brilho")
	
	if (destroyable):
		timer.timeout.connect(_on_timer_timeout)
		timer.start()
	
	await get_tree().create_timer(.2).timeout
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
	velocity.y += 400 * delta
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		DoFunction(body)
		queue_free()
		
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
			ui.AddScore(1000000)
		Item.invulnerable:
			body.emit_signal("invulnerability_ticks_started", 320, true)
		Item.health_star:
			ui.GainHealth()
		Item.life_duck:
			ui.GainLife()
		Item.cake:
			ui.ResetHealth()
		Item.ice_cream:
			ui.ReceiveCure(1)
