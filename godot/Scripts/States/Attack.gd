extends State
class_name Attack

@export var player: CharacterBody2D
@export var animation = &"Tacada"
@export var animation_failure = &"Tacada_Falha"
@export var animation_success = &"Tacada_Sucesso"

enum AttackState { None, Failure, Success }

var attacked = false
var attacking = false
var attacking_state: AttackState = AttackState.None

func enter() -> void:
	if player.is_on_floor():
		attacking = true
		player.animate(animation)
		await $"../../AnimatedSprite2D".animation_finished
		
		var collider = player.attack_raycast.get_collider()
		if can_attack(collider as PhysicsBody2D):
			attacking_state = AttackState.Success
		else:
			attacking_state = AttackState.Failure
			
		attacking = false

func exit() -> void:
	attacked = false
	attacking_state = AttackState.None

func update(_delta: float) -> void:
	if player.collisionWithEnemy and player.takingDamage:
		transitioned.emit(self, "damage")

func physics_update(delta: float) -> void:
	if attacking:
		return
	
	if not attacked:
		match attacking_state:
			AttackState.Failure:
				player.animate(animation_failure)
				await $"../../AnimatedSprite2D".animation_finished
				attacked = true
			AttackState.Success:
				player.animate(animation_success)
				await $"../../AnimatedSprite2D".animation_finished
				attacked = true
	else:
		if Input.is_action_pressed("left") or Input.is_action_pressed("right") and player.is_on_floor():
			transitioned.emit(self, "move")
		else:
			transitioned.emit(self, "idle")

	player.move_and_slide()
	
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"

func can_attack(body: PhysicsBody2D) -> bool:
	var can_attack = false
	if not body:
		return can_attack
	
	if body.has_signal("destroy_on_collision") and body.can_be_destroyed:
		body.emit_signal("destroy_on_collision", Vector2(1, -1) if player.lastDir == "right" else Vector2(-1, -1))
		can_attack = true
	if body.has_signal("fall_on_collision") and body.can_fall:
		body.emit_signal("fall_on_collision", Vector2(1, 1) if player.lastDir == "right" else Vector2(-1, 1))
		can_attack = true
	if body.has_signal("slide_on_collision") and body.can_slide:
		body.emit_signal("slide_on_collision", Vector2(1, 0) if player.lastDir == "right" else Vector2(-1, 0))
		can_attack = true
		
	return can_attack
