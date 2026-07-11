extends State

@export var speed_x := 60.0
@export var speed_y := 80.0

var actor

var fase := 0
var tempo := 0.0

func _ready():
	actor = get_parent().get_parent()

func enter() -> void:
	
	fase = 0
	tempo = 0.0

func physics_update(delta):
	actor.velocity.x = -50
	actor.move_and_slide()
