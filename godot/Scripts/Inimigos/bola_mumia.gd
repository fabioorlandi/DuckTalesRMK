extends RigidBody2D
class_name BolaMumia
signal destroy_on_collision

var can_be_destroyed = true
var projectile = false

func is_pogo_interactive():
	return true
	
func _physics_process(delta):
	self.modulate.a = 1
	var area = self.get_node("MonitorarMumia")
	for m in area.get_overlapping_bodies():
		if m.is_in_group("Inimigos"):
			self.modulate.a = sin(Time.get_ticks_msec() * 1.0) * 0.5 + 0.5

				
				

func _ready():
	
	add_to_group("Bola")
	var inimigos = get_tree().get_nodes_in_group("Inimigos")
	for inimigo in inimigos:
		self.add_collision_exception_with(inimigo)
		
		
	
	freeze = true
	destroy_on_collision.connect(destroy_body)
	
func destroy_body(direction: Vector2):
	
	freeze = false
	projectile = true
	apply_impulse(Vector2(80, 200) * direction)
	if direction != Vector2.ZERO:
		await get_tree().create_timer(0.3).timeout
	$"Ball Sprite".play("Explosão")
	await $"Ball Sprite".animation_finished
	queue_free()
	
func _on_die() -> void:
	$"Ball Sprite".play("Explosão")
	await $"Ball Sprite".animation_finished
	queue_free()
