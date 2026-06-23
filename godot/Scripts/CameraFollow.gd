extends Camera2D

@export var player: CharacterBody2D
@export var speed := 5.0

var onTransition: bool = false
var futurePos: int = 312

var follow_x = false 
var follow_y = false
var fixed_y: float

func _ready():
	fixed_y = global_position.y

func _process(delta):
	if follow_x:
		if player.onRope == true:
			global_position.x = player.ropeX
		else:
			global_position.x = player.global_position.x
	if follow_y:
		global_position.y = move_toward( global_position.y, futurePos, speed * delta )
		
		if onTransition == true and global_position.y == futurePos:
			onTransition = false
		
	else:
		global_position.y = fixed_y
