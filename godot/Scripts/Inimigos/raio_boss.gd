extends CharacterBody2D


@export var speed := 100
var direction := Vector2.ZERO
var can_hit_patinhas = true

func _ready():
	var inimigos = get_tree().get_nodes_in_group("Inimigos")
	for inimigo in inimigos:
		self.add_collision_exception_with(inimigo)
		
	var patinhas = get_tree().get_nodes_in_group("Patinhas")[0]
	self.add_collision_exception_with(patinhas)

func _process(delta):
	position += direction * speed * delta



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
