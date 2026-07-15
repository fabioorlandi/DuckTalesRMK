extends State

@export var animation = &"Walk_Mummy"
@export var speed := 20.0
@export var walk_time := 0.8

var actor
var timer := 0.0


func _ready():
	actor = get_parent().get_parent()


func enter() -> void:
	if actor.is_dead: 
		return
	timer = 0.0
	var anim = actor.get_node("AnimatedSprite2D")
	anim.play(animation)
	actor.get_node("AnimatedSprite2D").flip_h = true

func update(delta: float) -> void:
	if actor.is_dead: 
		return
	timer += delta

	if timer >= walk_time:
		actor.velocity = Vector2.ZERO
		transitioned.emit(self, "return_from_left")


func physics_update(_delta: float) -> void:
	if actor.is_dead: 
		return
	if timer < walk_time:
		actor.velocity.x = -1 * speed
	else:
		actor.velocity.x = 0
	if actor.is_dead:
			actor.velocity.x = 0 
			actor.move_and_slide() 
			return 
	actor.move_and_slide()
