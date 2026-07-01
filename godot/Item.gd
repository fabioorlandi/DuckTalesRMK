extends CharacterBody2D

enum Item { yellow_diamond_G, yellow_diamond_P, red_diamond_G, stage_trophy, skeleton_key, 
			cake, ice_cream, invulnerable, health_star, life_duck  }
			
@export var current_item: Item

var on_fade: bool = false

@onready var timer: Timer = $Timer
var timeLeft: int = 6

const gravity = -400.0
const y_force := -50.0

@export var destroyable: bool

func _ready() -> void:
	$AnimatedSprite2D.play("brilho")
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	velocity.y = 0
	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - 25,
		0.15
	)
	
	if(destroyable):
		timer.timeout.connect(_on_timer_timeout)
		timer.start()

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
		DoFunction()
		queue_free()
		
func DoFunction() -> void:
	match  current_item:
		Item.yellow_diamond_G:
			$"../UI".AddScore(10000)
		Item.yellow_diamond_P:
			$"../UI".AddScore(2000)
		Item.red_diamond_G:
			$"../UI".AddScore(50000)
		Item.stage_trophy:
			$"../UI".AddScore(1000000)
		Item.invulnerable:
			#set player invulnerable per 8s
			pass
		Item.health_star:
			$"../UI".GainHealth()
		Item.life_duck:
			$"../UI".GainLife()
		Item.cake:
			$"../UI".ResetHealth()
		Item.ice_cream:
			$"../UI".ReceiveCure(1)
