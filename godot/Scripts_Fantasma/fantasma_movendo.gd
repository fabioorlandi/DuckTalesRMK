extends State

@export var speed_y := 90.0

var actor
var player
var direction
var base_y

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	player = get_tree().get_first_node_in_group("Patinhas")
	if player == null:
		return
	
	direction = -1 if player.global_position.x < actor.global_position.x else 1
	base_y = actor.position.y
	
	var tween = create_tween()
	tween.set_loops() 
	tween.tween_property(actor, "position:y", base_y - 15, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	# TOPO 
	tween.tween_property(actor, "position:y", base_y - 30, 0.4)
	tween.tween_property(actor, "position:y", base_y - 15, 0.4)
	tween.tween_property(actor, "position:y", base_y - 30, 0.4)
	tween.tween_property(actor, "position:y", base_y - 15, 0.4)
	tween.tween_property(actor, "position:y", base_y - 20, 0.4)

	# DESCE
	tween.tween_property(actor, "position:y", base_y, 0.3)

	# EMBAIXO (rápido)
	tween.tween_property(actor, "position:y", base_y - 5, 0.2)
	tween.tween_property(actor, "position:y", base_y - 10, 0.2)
	tween.tween_property(actor, "position:y", base_y - 5, 0.2)

func physics_update(_delta):
	actor.velocity.x = direction * 70
	actor.move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	actor.queue_free()
	print("sumi")
