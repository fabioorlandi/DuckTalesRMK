extends State
class_name Atirando

var actor

func _ready():
	actor = get_parent().get_parent()

func enter():
	actor.velocity = Vector2.ZERO
	actor.can_hit_patinhas = false
	$"../../AnimatedSprite2D".play("Pousar")
	
	shoot_sequence()

func shoot_sequence():
	$"../../AnimatedSprite2D".play("Atirar")
	for i in 3:
		#atirar()
		await get_tree().create_timer(0.3).timeout
	
	transitioned.emit(self, "decolando")
	
#func atirar():
	#var proj = preload("res://raio.tscn").instantiate()
	#proj.global_position = actor.global_position
	
	
	#proj.direction = Vector2(-1, 0)
	
	#get_tree().current_scene.add_child(proj)
