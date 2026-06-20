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
		
		var collider = $"../../RayCast2D".get_collider()
		if can_attack(collider as PhysicsBody2D):
			attacking_state = AttackState.Success
		else:
			attacking_state = AttackState.Failure
			
		attacking = false

func exit() -> void:
	attacked = false
	attacking_state = AttackState.None

func update(_delta: float) -> void:
	pass

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

	#saveLastDir
	if Input.is_action_pressed("left"):
		player.lastDir = "left"
	elif Input.is_action_pressed("right"):
		player.lastDir = "right"

func can_attack(body: PhysicsBody2D) -> bool:
	var can_attack = false
	if not body:
		return can_attack
	
	if body.has_signal("destroy_on_collision"):
		body.emit_signal("destroy_on_collision")
		can_attack = true
	if body.has_signal("fall_on_collision"):
		body.emit_signal("fall_on_collision")
		can_attack = true
	if body.has_signal("slide_on_collision"):
		body.emit_signal("slide_on_collision")
		can_attack = true
		
	return can_attack
