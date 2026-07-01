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
	$"../../../Ball/Chain_Right".visible = true
	# 1) idle primeiro
	var anim = actor.get_node("AnimatedSprite2D")
	anim.play(animation_idle)

	_run_sequence()


func _run_sequence() -> void:
	await get_tree().create_timer(1.2).timeout
	$"../../../Ball/Chain_Right".visible = false
	actor.get_node("AnimatedSprite2D").flip_h = true
	# 2) começa a andar de volta
	var anim = actor.get_node("AnimatedSprite2D")
	anim.play(animation_walk)

	var dir := -1  # return from right = volta pra esquerda

	var walk_time := 0.8
	var t := 0.0

	while t < walk_time:
		await get_tree().process_frame
		actor.velocity.x = dir * speed
		actor.move_and_slide()
		t += get_process_delta_time()

	# 3) para tudo e volta pro idle
	actor.velocity = Vector2.ZERO
	transitioned.emit(self, "idle_mummy")
