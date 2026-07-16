extends State
class_name Voando

var actor
var tempo := 0.0
var tween
func _ready():
	actor = get_parent().get_parent()

func _physics_process(delta: float) -> void:
	if actor.morrendo:
		if tween:
			tween.kill()
		return
func enter():
	$"../../AnimatedSprite2D".play("Voar")
	tempo = 0.0
	tween = create_tween()
	tween.set_loops()
	
	var y0 = actor.position.y
	
	tween.tween_property(actor, "position:y", y0 - 10, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(actor, "position:y", y0 + 10, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	actor.can_hit_patinhas = true

func physics_update(delta):
	if actor.morrendo:
		return
	tempo += delta
	
	actor.velocity.x = actor.direction * 80
	actor.move_and_slide()
	
	# troca direção nas bordas (exemplo)
	if actor.is_on_wall():
		actor.direction *= -1
	
	var sprite: AnimatedSprite2D = actor.get_node("AnimatedSprite2D")
	sprite.flip_h = actor.direction < 0
	# depois de um tempo, pousa
	if tempo > [8.0, 8.0, 8.0, 6.0, 6.0, 4.0, 10].pick_random():
		transitioned.emit(self, "pousando")
		
func exit():
	if tween:
		tween.kill()
