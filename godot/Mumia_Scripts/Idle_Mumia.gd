extends State

@export var animation = &"Idle_Mummy"
@export var reactivate_delay := 1.2

var actor
var timer := 0.0


func _ready():
	actor = get_parent().get_parent()


func enter() -> void:
	if actor.is_dead: 
		return
	timer = 0.0
	actor.velocity = Vector2.ZERO

	var anim = actor.get_node("AnimatedSprite2D")
	anim.play(animation)


func update(delta):
	#if actor.is_dead: 
		#return
	timer += delta
	if timer < reactivate_delay:
		return

	timer = 0.0

	var next_state = ["walk_mummy_left", "walk_mummy_right"].pick_random()
	transitioned.emit(self, next_state)
