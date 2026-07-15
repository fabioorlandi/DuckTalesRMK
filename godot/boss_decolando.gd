extends State
class_name Decolando

var actor
var target_y 

func _ready():
	actor = get_parent().get_parent()

func enter():
	await get_tree().create_timer(1.0).timeout
	$"../../AnimatedSprite2D".play("Decolar")
	await $"../../AnimatedSprite2D".animation_finished
	target_y = actor.global_position.y - 30
	
	
	actor.velocity = Vector2(0, -120)

func physics_update(delta):

	actor.move_and_slide()
	
	if actor.global_position.y == target_y:
		actor.global_position.y = target_y
		actor.velocity = Vector2.ZERO
		transitioned.emit(self, "voando")
