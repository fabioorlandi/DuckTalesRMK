extends State
class_name Atirando
@export var raio_scene: PackedScene
var spawn_point
var actor
@onready var metade_area: Area2D = $"../../../Area_Boss"
func _ready():
	actor = get_parent().get_parent()
	spawn_point = actor.get_node("SpawnRaio")
func _physics_process(delta: float) -> void:
	if actor.morrendo:
		return
func enter():
	
	actor.velocity = Vector2.ZERO
	$"../../AnimatedSprite2D".play("Pousar")
	await get_tree().create_timer(0.8).timeout
	shoot_sequence()
func physics_update(delta):
	if actor.morrendo:
		return
		
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	
	if metade_area.overlaps_body(actor):
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func shoot_sequence():
	$"../../AnimatedSprite2D".play("Atirar")
	await get_tree().create_timer(0.2).timeout
	atirar_1()
	atirar_2()
	atirar_3()
	await get_tree().create_timer(0.3).timeout
	
	transitioned.emit(self, "decolando")
	
func atirar_1():
	var raio = raio_scene.instantiate()
	get_tree().current_scene.add_child(raio)
	
	raio.global_position = spawn_point.global_position
	
	raio.direction = Vector2.UP
func atirar_2():
	var raio = raio_scene.instantiate()
	get_tree().current_scene.add_child(raio)
	
	raio.global_position = spawn_point.global_position
	if metade_area.overlaps_body(actor):
		
		raio.direction = Vector2.RIGHT
	else:
		
		raio.direction = Vector2.LEFT
	
func atirar_3():
	var raio = raio_scene.instantiate()
	get_tree().current_scene.add_child(raio)
	
	raio.global_position = spawn_point.global_position
	if metade_area.overlaps_body(actor):
		
		raio.direction = (Vector2.UP + Vector2.RIGHT).normalized()
	else:
		
		raio.direction = (Vector2.UP + Vector2.LEFT).normalized()
