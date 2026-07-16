extends State
class_name Decolando

var actor
var target_y


func _ready():
	actor = get_parent().get_parent()
	

		
func enter():
	await get_tree().create_timer(0.4).timeout
	$"../../AnimatedSprite2D".play("Decolar")
	await $"../../AnimatedSprite2D".animation_finished
	target_y = [actor.global_position.y - 40, actor.global_position.y - 80, actor.global_position.y - 100].pick_random()
	
	
	actor.velocity = Vector2(0, -120)
func _physics_process(delta: float) -> void:
	if actor.morrendo:
		return
func physics_update(delta):
	
	if actor.morrendo:
		return
	if target_y == null:
		return
	
	actor.move_and_slide()
	
	if actor.global_position.y <= target_y:
		actor.global_position.y = target_y
		actor.velocity = Vector2.ZERO
		transitioned.emit(self, "voando")
