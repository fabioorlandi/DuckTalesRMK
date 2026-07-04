extends State
class_name Damage

var taking_damage = false
@export var player: CharacterBody2D
@export var animation = &"Dano"
 
func enter() -> void:
	player.canClimb = false
	taking_damage = true

	player.emit_signal("invulnerability_ticks_started", 200)
	
	var tween = create_tween()
	var damage_recoil = player.position + Vector2(20, -20)\
		if player.lastDir == "left"\
		else player.position + Vector2(-20, -20)
	tween.tween_property(player, "position", damage_recoil, 0.15)
	
	player.animate(animation)
	await $"../../AnimatedSprite2D".animation_finished
	taking_damage = false

func update(_delta: float) -> void:
	pass
 
func physics_update(delta: float) -> void:
	if taking_damage:
		return

	if not player.is_on_floor():
		transitioned.emit(self, "fall")

	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"
 
	player.move_and_slide()
