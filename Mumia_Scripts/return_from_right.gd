extends State

@export var animation_idle = &"Idle_Mummy"
@export var animation_walk = &"Walk_Mummy"
@export var speed := 20.0

var actor


func _ready():
	actor = get_parent().get_parent()


func physics_update(_delta: float) -> void:
	if actor.is_dead:
			actor.velocity.x = 0 
			actor.move_and_slide() 
			return 

func enter() -> void:
	if actor.is_dead:
		return

	actor.velocity = Vector2.ZERO
	
	var anim = actor.get_node("AnimatedSprite2D")
	anim.play(animation_idle)
	var area = actor.get_node("MonitorarBola")
	for b in area.get_overlapping_bodies():
		if b.is_in_group("bola"):
			actor.get_node("Chain_Left").visible = true

	_run_sequence()

func _run_sequence() -> void:
	await get_tree().create_timer(1.2).timeout
	actor.get_node("Chain_Left").visible = false

	if actor.is_dead:
		return

	actor.get_node("AnimatedSprite2D").flip_h = true
	
	var anim = actor.get_node("AnimatedSprite2D")
	anim.play(animation_walk)

	var dir := -1 
	var walk_time := 0.8
	var t := 0.0

	while t < walk_time:
		await get_tree().process_frame
		
		if actor.is_dead:
			return

		actor.velocity.x = dir * speed
		actor.move_and_slide()
		t += get_process_delta_time()

	actor.velocity = Vector2.ZERO
	transitioned.emit(self, "idle_mummy")
